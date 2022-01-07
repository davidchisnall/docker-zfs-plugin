module github.com/apetresc/docker-zfs-plugin

go 1.13

require (
	github.com/Microsoft/go-winio v0.5.1 // indirect
	github.com/clinta/go-zfs v0.0.0-20181025145938-e5fe14d9dcb7
	github.com/coreos/go-systemd v0.0.0-20191104093116-d3cd4ed1dbcf
	github.com/cpuguy83/go-md2man/v2 v2.0.1 // indirect
	github.com/docker/go-connections v0.4.0 // indirect
	github.com/docker/go-plugins-helpers v0.0.0-20211224144127-6eecb7beb651
	github.com/sirupsen/logrus v1.8.1
	github.com/urfave/cli v1.22.5
	golang.org/x/net v0.0.0-20220105145211-5b0dc2dfae98 // indirect
	golang.org/x/sys v0.0.0-20211216021012-1d35b9e2eb4e // indirect
)

replace github.com/docker/go-plugins-helpers => github.com/clinta/go-plugins-helpers v0.0.0-20200221140445-4667bb9f0ed5 // for shutdown
