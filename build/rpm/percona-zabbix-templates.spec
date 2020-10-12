Name:           percona-zabbix-templates
Summary:        Percona Monitoring Plugins for Zabbix
Version:        %{version}
Release:        %{release}
Group:          Applications/Databases
License:        GPL
Vendor:         Percona
URL:            http://www.percona.com/software/percona-monitoring-plugins
Source:         percona-zabbix-templates-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch:      noarch
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
install -m 0755 -d $RPM_BUILD_ROOT/var/lib/zabbix/percona/scripts
install -m 0755 -d $RPM_BUILD_ROOT/var/lib/zabbix/percona/templates
install -m 0755 zabbix/scripts/* $RPM_BUILD_ROOT/var/lib/zabbix/percona/scripts
install -m 0644 zabbix/templates/* $RPM_BUILD_ROOT/var/lib/zabbix/percona/templates

%clean
rm -rf $RPM_BUILD_ROOT

%post
echo
echo "Scripts are installed to /var/lib/zabbix/percona/scripts"
echo "Templates are installed to /var/lib/zabbix/percona/templates"

%files
%dir /var/lib/zabbix/percona
/var/lib/zabbix/percona/*

%changelog
* Mon Oct 21 2013 <roman.vynar@percona.com> 1.1.0
- Initial Package
