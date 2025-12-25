all : src/main.o src/cloudchatdat.o src/cloudchatuser.o src/cloudchatmsg.o src/cloudchatgroup.o src/cloudchatservice.o src/cloudchatsys.o
	g++ src/cloudchatservice.o src/main.o src/cloudchatdat.o src/cloudchatuser.o src/cloudchatmsg.o src/cloudchatgroup.o src/cloudchatsys.o -o cloudchat_server -lmysqlcppconn

src/main.o : src/main.cpp
	g++ -g -c src/main.cpp -I include -o src/main.o

src/cloudchatdat.o : src/cloudchatdat.cpp
	g++ -g -c src/cloudchatdat.cpp -I include -o src/cloudchatdat.o

src/cloudchatuser.o : src/cloudchatuser.cpp
	g++ -g -c src/cloudchatuser.cpp -I include -o src/cloudchatuser.o

src/cloudchatmsg.o : src/cloudchatmsg.cpp
	g++ -g -c src/cloudchatmsg.cpp -I include -o src/cloudchatmsg.o

src/cloudchatgroup.o : src/cloudchatgroup.cpp
	g++ -g -c src/cloudchatgroup.cpp -I include -o src/cloudchatgroup.o

src/cloudchatservice.o : src/cloudchatservice.cpp
	g++ -g -c src/cloudchatservice.cpp -I include -o src/cloudchatservice.o

src/cloudchatsys.o : src/cloudchatsys.cpp
	g++ -g -c src/cloudchatsys.cpp -I include -o src/cloudchatsys.o

clean:
	rm -f cloudchat_server
	rm -f src/*.o
