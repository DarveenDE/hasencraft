#!/usr/bin/env bash
set -Eeuo pipefail

[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo "Run this installer as root." >&2; exit 1; }

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
root=/srv/hasencraft
server_dir="$root/server"
tools_dir="$root/tools"
config_dir=/etc/hasencraft
libexec_dir=/usr/local/libexec
service_file=/etc/systemd/system/hasencraft.service
neoforge_version=21.1.248
installer="$tools_dir/neoforge-$neoforge_version-installer.jar"
installer_url="https://maven.neoforged.net/releases/net/neoforged/neoforge/$neoforge_version/neoforge-$neoforge_version-installer.jar"

apt-get update
apt-get install -y openjdk-21-jre-headless ca-certificates curl util-linux zstd

if ! id hasencraft >/dev/null 2>&1; then
  useradd --system --home-dir "$root" --create-home --shell /usr/sbin/nologin hasencraft
fi

install -d -o hasencraft -g hasencraft -m 0750 "$server_dir" "$root/backups"
install -d -o root -g hasencraft -m 0750 "$tools_dir"
touch "$root/.lifecycle.lock"
chown root:hasencraft "$root/.lifecycle.lock"
chmod 0660 "$root/.lifecycle.lock"
install -d -o root -g hasencraft -m 0750 "$config_dir"
install -m 0640 -o root -g hasencraft "$script_dir/hasencraft.env.example" "$config_dir/hasencraft.env.example"
if [[ ! -e "$config_dir/hasencraft.env" ]]; then
  install -m 0640 -o root -g hasencraft "$script_dir/hasencraft.env.example" "$config_dir/hasencraft.env"
fi

install -m 0755 "$script_dir/bin/hasencraft-deploy" "$libexec_dir/hasencraft-deploy"
install -m 0755 "$script_dir/bin/hasencraft-backup" "$libexec_dir/hasencraft-backup"
install -m 0755 "$script_dir/bin/hasencraft-rollback" "$libexec_dir/hasencraft-rollback"
install -m 0644 "$script_dir/hasencraft.service" "$service_file"
if [[ ! -e "$server_dir/user_jvm_args.txt" ]]; then
  install -m 0640 -o hasencraft -g hasencraft "$script_dir/user_jvm_args.txt" "$server_dir/user_jvm_args.txt"
fi
install -m 0640 -o hasencraft -g hasencraft "$script_dir/server.properties.example" "$server_dir/server.properties.example"
install -m 0640 -o root -g hasencraft "$script_dir/../launcher/bootstrap/packwiz-installer-bootstrap.jar" "$tools_dir/packwiz-installer-bootstrap.jar"
install -d -o hasencraft -g hasencraft -m 0750 "$server_dir/config"
if [[ ! -e "$server_dir/config/DistantHorizons.toml" ]]; then
  install -m 0640 -o hasencraft -g hasencraft "$script_dir/config/DistantHorizons.toml" "$server_dir/config/DistantHorizons.toml"
fi

if [[ ! -f "$server_dir/run.sh" ]]; then
  curl -fsSLo "$installer" "$installer_url"
  curl -fsSLo "$installer.sha1" "$installer_url.sha1"
  expected="$(tr -d '[:space:]' < "$installer.sha1")"
  actual="$(sha1sum "$installer" | awk '{print $1}')"
  [[ "$actual" == "$expected" ]] || { echo "NeoForge installer hash mismatch." >&2; exit 1; }
  chown root:hasencraft "$installer" "$installer.sha1"
  chmod 0640 "$installer" "$installer.sha1"
  runuser -u hasencraft -- bash -c "cd '$server_dir' && /usr/bin/java -jar '$installer' --installServer"
fi

if [[ ! -e "$server_dir/eula.txt" ]]; then
  printf 'eula=false\n' > "$server_dir/eula.txt"
  chown hasencraft:hasencraft "$server_dir/eula.txt"
  chmod 0640 "$server_dir/eula.txt"
fi

systemctl daemon-reload
systemctl enable hasencraft.service

cat <<'EOF'
Hasencraft server files installed.

Before the first start:
1. Edit /etc/hasencraft/hasencraft.env and set real pack URLs.
2. Copy server.properties.example to server.properties and review it.
3. Read the Minecraft EULA and set eula=true only if you accept it.
4. Run: systemctl stop hasencraft
5. Run: sudo -u hasencraft /usr/local/libexec/hasencraft-deploy stable
6. Run: systemctl start hasencraft
7. Open UDP 24454 if Simple Voice Chat should be used.
EOF
