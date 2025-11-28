all : src/main.o src/cloudchatdat.o src/cloudchatuser.o
	g++ src/main.o src/cloudchatdat.o src/cloudchatuser.o  -o cloudchat_server -lmysqlcppconn

src/main.o : src/main.cpp
	g++ -g -c src/main.cpp -I include -o src/main.o

src/cloudchatdat.o : src/cloudchatdat.cpp
	g++ -g -c src/cloudchatdat.cpp -I include -o src/cloudchatdat.o

src/cloudchatuser.o : src/cloudchatuser.cpp
	g++ -g -c src/cloudchatuser.cpp -I include -o src/cloudchatuser.o

clean:
	rm -f cloudchat_server
	rm -f src/*.o
