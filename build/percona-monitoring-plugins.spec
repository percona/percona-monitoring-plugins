Name:           percona-monitoring-plugins
Summary:        Percona Monitoring Plugins are high-quality components to add enterprise-class MySQL monitoring and graphing capabilities to your existing on-premise monitoring solutions.
Group:          Applications/Databases
Version:        %{version}
Release:        %{release}
Distribution:   %{distro_description}
License:        GPL
Source:         percona-monitoring-plugins-%{version}.tar.gz
URL:            http://www.percona.com/software/percona-monitoring-plugins
Packager:       Percona MySQL Development Team <mysqldev@percona.com>
Vendor:         Percona
BuildArch:      noarch
BuildRoot:    %{_tmppath}/%{name}-%{version}-build
BuildRequires:  PyYAML
%if 0%{?rhel} > 6
BuildRequires: perl-Digest-MD5
%else
BuildRequires: perl-MD5
%endif


%description
Summary:        Percona Monitoring Plugins are high-quality components to add enterprise-class MySQL monitoring and graphing capabilities to your existing on-premise monitoring solutions.


##############################################################################
# Sub package definition
##############################################################################


%package -n     percona-cacti-templates
Summary:        Percona Monitoring Plugins for Cacti
Group:          Applications/Databases
License:        GPL
Requires:       cacti >= 0.8.6

%description -n percona-cacti-templates
The Percona Monitoring Plugins are high-quality components to add enterprise-
grade MySQL monitoring and graphing capabilities to your existing in-house,
on-premises monitoring solutions. The components are designed to integrate
seamlessly with widely deployed solutions such as Nagios, Cacti and Zabbix,
and are delivered in the form of templates, plugins, and scripts.


%package -n     percona-nagios-plugins
Summary:        Percona Monitoring Plugins for Nagios
Group:          Applications/Databases
License:        GPL

%description -n percona-nagios-plugins
The Percona Monitoring Plugins are high-quality components to add enterprise-
grade MySQL monitoring and graphing capabilities to your existing in-house,
on-premises monitoring solutions. The components are designed to integrate
seamlessly with widely deployed solutions such as Nagios, Cacti and Zabbix,
and are delivered in the form of templates, plugins, and scripts.


%package -n     percona-zabbix-templates
Summary:        Percona Monitoring Plugins for Zabbix
Group:          Applications/Databases
License:        GPL

%description -n percona-zabbix-templates
The Percona Monitoring Plugins are high-quality components to add enterprise-
grade MySQL monitoring and graphing capabilities to your existing in-house,
on-premises monitoring solutions. The components are designed to integrate
seamlessly with widely deployed solutions such as Nagios, Cacti and Zabbix,
and are delivered in the form of templates, plugins, and scripts.

##############################################################################


%prep
%setup -q

%build
./make.sh nodocs
TARFILE=$(basename $(find . -name 'percona-monitoring-plugins-*.tar.gz' | sort | tail -n1))
tar -zxvf ${TARFILE}

%install

#========ZABBIX========
install -m 0755 -d $RPM_BUILD_ROOT/var/lib/zabbix/percona/scripts
install -m 0755 -d $RPM_BUILD_ROOT/var/lib/zabbix/percona/templates
install -m 0755 release/%{name}-%{version}/zabbix/scripts/* $RPM_BUILD_ROOT/var/lib/zabbix/percona/scripts
install -m 0644 release/%{name}-%{version}/zabbix/templates/* $RPM_BUILD_ROOT/var/lib/zabbix/percona/templates
#======================

#========NAGIOS========
install -m 0755 -d $RPM_BUILD_ROOT%{_libdir}/nagios/plugins
install -m 0755 release/%{name}-%{version}/nagios/bin/pmp-* $RPM_BUILD_ROOT%{_libdir}/nagios/plugins
#======================

#========CACTI=========
install -m 0755 -d $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/bin
install -m 0755 -d $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/definitions
install -m 0755 -d $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/misc
install -m 0755 -d $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/templates
install -m 0755 -d $RPM_BUILD_ROOT/usr/share/cacti/scripts
install -m 0755 release/%{name}-%{version}/cacti/bin/* $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/bin
install -m 0644 release/%{name}-%{version}/cacti/definitions/* $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/definitions
install -m 0644 release/%{name}-%{version}/cacti/misc/* $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/misc
install -m 0644 release/%{name}-%{version}/cacti/templates/* $RPM_BUILD_ROOT/usr/share/cacti/resource/percona/templates
install -m 0644 release/%{name}-%{version}/cacti/scripts/*.php $RPM_BUILD_ROOT/usr/share/cacti/scripts
install -m 0755 release/%{name}-%{version}/cacti/scripts/*.py $RPM_BUILD_ROOT/usr/share/cacti/scripts
#======================

# exit 0 disables running helpers which generates *.pyc, *.pyo files.
exit 0

%clean
rm -rf $RPM_BUILD_ROOT

%post -n percona-zabbix-templates
echo
echo "Scripts are installed to /var/lib/zabbix/percona/scripts"
echo "Templates are installed to /var/lib/zabbix/percona/templates"


%files -n percona-zabbix-templates
%dir /var/lib/zabbix/percona
/var/lib/zabbix/percona/*


%post -n percona-nagios-plugins
echo
echo "Plugins are installed to %{_libdir}/nagios/plugins"


%files -n percona-nagios-plugins
%{_libdir}/nagios/plugins/*


%post -n percona-cacti-templates
echo
echo "Scripts are installed to /usr/share/cacti/scripts"
echo "Templates are installed to /usr/share/cacti/resource/percona"


%files -n percona-cacti-templates
%dir /usr/share/cacti/resource/percona
/usr/share/cacti/resource/percona/*
/usr/share/cacti/scripts/*


%changelog
* Thu Dec  1 2016 <evgeniy.patlan@percona.com> 1.1.7
- Initial Package
