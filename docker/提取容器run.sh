#!/bin/bash

container="$1"

# 基础信息
name=$(docker inspect "$container" --format='{{.Name}}' | sed 's|^/||')
image=$(docker inspect "$container" --format='{{.Config.Image}}')
restart=$(docker inspect "$container" --format='{{.HostConfig.RestartPolicy.Name}}')
network=$(docker inspect "$container" --format='{{.HostConfig.NetworkMode}}')
cmd=$(docker inspect "$container" --format='{{range .Config.Cmd}}{{.}} {{end}}' | xargs)

# 构建命令
run_cmd="docker run -d --name=\"$name\" --restart=$restart"

# 网络
if [ "$network" != "default" ] && [ "$network" != "bridge" ]; then
    run_cmd="$run_cmd --network=$network"
fi

# 端口
ports=$(docker inspect "$container" --format='{{range $p, $conf := .NetworkSettings.Ports}}{{if $conf}}-p {{(index $conf 0).HostPort}}:{{$p}} {{end}}{{end}}')
[ -n "$ports" ] && run_cmd="$run_cmd $ports"

# 卷
volumes=$(docker inspect "$container" --format='{{range .Mounts}}{{if .Source}}-v {{.Source}}:{{.Destination}} {{end}}{{end}}')
[ -n "$volumes" ] && run_cmd="$run_cmd $volumes"

# 环境变量过滤

container_env=$(docker inspect "$container" --format='{{range .Config.Env}}{{println .}}{{end}}')
image_env=$(docker inspect "$image" --format='{{range .Config.Env}}{{println .}}{{end}}' 2>/dev/null || echo "")

custom_envs=""
while IFS= read -r env_line; do
    if [ -n "$env_line" ]; then
        # 方法1：检查是否镜像自带
        if [ -z "$image_env" ] || ! echo "$image_env" | grep -Fxq "$env_line"; then
            # 方法2：检查是否是常见基础变量
            if [[ ! "$env_line" =~ ^(PATH|HOME|HOSTNAME|TERM|SHELL|USER|PWD|LANG|LANGUAGE|LC_|SHLVL|DEBIAN_FRONTEND)= ]]; then
                custom_envs="$custom_envs -e \"$env_line\""
            fi
        fi
    fi
done <<< "$container_env"

[ -n "$custom_envs" ] && run_cmd="$run_cmd $custom_envs"

# 其他参数
[ "$(docker inspect "$container" --format='{{.HostConfig.Privileged}}')" = "true" ] && run_cmd="$run_cmd --privileged"

user=$(docker inspect "$container" --format='{{.Config.User}}')
[ -n "$user" ] && [ "$user" != "" ] && run_cmd="$run_cmd --user=$user"

# 最终命令
run_cmd="$run_cmd $image"
[ -n "$cmd" ] && run_cmd="$run_cmd $cmd"

echo "$run_cmd"

