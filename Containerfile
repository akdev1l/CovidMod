FROM fedora:latest

RUN dnf -y install mono-devel make git curl nuget findutils
