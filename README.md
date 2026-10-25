# About

This is a project you can use to alert yourself when your systemd service unit fails. Upon failure a graphical window immediately pops up with the logs from journalctl from the run that failed.

<img width="1220" height="auto" alt="Screenshot_20261025_153012" src="https://github.com/user-attachments/assets/11bf4b8e-e9a7-423c-8ae1-ae4d1b479e6a" />
<br><br>

This project isolates itself from any breakages due to system updates by managing it's dependencies with [uv](https://docs.astral.sh/uv/), a python manager *and* python package manager.

# Use

In your service file:

```
[Unit]
Description=My description of this service
OnFailure=systemd-failure@%N.service

[Service]
ExecStart=/path/to/executable args
```

The key part is the OnFailure line, where you name the failure service. Be sure to include the @ symbol followed by the %N [specifier](https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html#Specifiers). This tells systemd to create a unique systemd-failure.service for each of your services that include it OnFailure. Otherwise if you include `OnFailure=systemd-failure.service` without `@%N` in more than one of your services it will not work.

# Installation

Install [uv](/https://docs.astral.sh/uv/getting-started/installation/), an extremely fast Python package and project manager, written in Rust.

Then... 
```
gh repo clone frflcn/SystemdFailure
cd SystemdFailure
uv run systemdfailure
```
If all went well you should see an empty dialog box.<br><br>
Now create your service file for systemd-failure:
```
# /etc/systemd/user/systemd-failure@.service

[Unit]
Description=A service that alerts if %i has failed

[Service]
ExecStart=uv run --project /path/to/SystemdFailure systemdfailure

```
That's it. You can include it in your own service files as shown above.

# Known Limitations

As of now, only one window will pop-up at a time. Meaning if another error occurs before you closed the previous pop-up, no new pop-up will be shown.
