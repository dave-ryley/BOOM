FROM ubuntu
RUN apt update && apt install -y \
	luarocks

RUN luarocks install luacheck

