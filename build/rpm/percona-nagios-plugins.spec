Name:		percona-nagios-plugins
Summary:	Percona Monitoring Plugins for Nagios
Version:	%{version} 
Release:	%{release}
Group:		Applications/Databases
License:	GPL
Vendor:         Percona
URL:		http://www.percona.com/software/percona-monitoring-plugins
Source:         percona-nagios-plugins-%{version}.tar.gz
BuildRoot:	%{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch:	noarch
AutoReq:	no

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
install -m 0755 -d $RPM_BUILD_ROOT%{_libdir}/nagios/plugins
install -m 0755 nagios/bin/pmp-* $RPM_BUILD_ROOT%{_libdir}/nagios/plugins

%clean
rm -rf $RPM_BUILD_ROOT

%post
echo
echo "Plugins are installed to %{_libdir}/nagios/plugins"

%files
%{_libdir}/nagios/plugins/*

%changelog
* Fri Jan 22 2013 <roman.vynar@percona.com> 1.0.2
- Initial Package 
