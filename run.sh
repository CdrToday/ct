case $1 in
    icon)
	flutter pub run flutter_launcher_icons:main
	;;
    *)
	NO_PROXY=127.0.0.1 flutter run -d all --enable-software-rendering --pid-file /tmp/flutter.pid
	;;
esac
	
	  


