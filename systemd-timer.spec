%define upstream systemd-timer
%define rsc_dir /usr/lib/ocf/resource.d/devgateway

Name:           resource-agent-%{upstream}
Summary:        Resource Agent for Pacemaker to manage Systemd timer units
Vendor:         Development Gateway
License:        GPLv3+
URL:            https://github.com/devgateway/pacemaker-ra-systemd-timer

Version:        0.1
Release:        %{rel}

Requires:       systemd

Source:         %{upstream}.tar.gz
BuildArch:      noarch
BuildRequires:  make

%description
Resource Agent for Pacemaker to manage Systemd timer units

%prep
%setup -n %{upstream}-%{version}

%build
make

%install
mkdir -p %{buildroot}%{rsc_dir}
install -m 0755 systemd-timer %{buildroot}%{rsc_dir}/

%files
/usr/lib/ocf/resource.d/devgateway
