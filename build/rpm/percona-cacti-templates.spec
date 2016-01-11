Name:           percona-cacti-templates
Summary:        Percona Monitoring Plugins for Cacti
Version:        %{version}
Release:        %{release}
Group:          Applications/Databases
License:        GPL
Vendor:         Percona
URL:            http://www.percona.com/software/percona-monitoring-plugins
Source:         percona-cacti-templates-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch:      noarch
Requires:       cacti >= 0.8.6
AutoReq:        no

%description
The Percona Monitoring Plugins are high-quality components to add enterprise-
grade MySQL monitoring and graphing capabilities to your existing in-house,
on-premises monitoring solutions. The components are designed to integrate
seamlessly with widely deployed solutions such as Nagios, Cacti and Zabbix,
and are delivered in the form of templates, plugins, and scripts.

%prep
%setup -q

%build

%install
install -m 0755 -d $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/bin
install -m 0755 -d $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/definitions
install -m 0755 -d $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/misc
install -m 0755 -d $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/templates
install -m 0755 -d $RPM_BUILD_ROOT/usr/share/cacti/scripts
install -m 0755 cacti/bin/* $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/bin
install -m 0644 cacti/definitions/* $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/definitions
install -m 0644 cacti/misc/* $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/misc
install -m 0644 cacti/templates/* $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/templates
install -m 0644 cacti/scripts/*.php $RPM_BUILD_ROOT/usr/share/cacti/scripts
install -m 0755 cacti/scripts/*.py $RPM_BUILD_ROOT/usr/share/cacti/scripts
# exit 0 disables running helpers which generates *.pyc, *.pyo files.
exit 0

%clean
rm -rf $RPM_BUILD_ROOT

%post
echo
echo "Scripts are installed to /usr/share/cacti/scripts"
echo "Templates are installed to /usr/share/cacti/resource/percona"

%files
%dir /usr/share/cacti/resource/percona
/usr/share/cacti/resource/percona/*
/usr/share/cacti/scripts/*

%changelog
* Fri Jan 22 2013 <roman.vynar@percona.com> 1.0.2
- Initial Package
