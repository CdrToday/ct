case $1 in
    icon)
	flutter pub run flutter_launcher_icons:main
	;;
    *)
	flutter run -d all --enable-software-rendering --pid-file /tmp/flutter.pid
	;;
esac
	
	  


