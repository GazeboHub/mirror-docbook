ANT = ant
ANT_OPTS =

all: jars

jars: saxon8.jar

saxon8.jar: saxon/build/saxon.jar
	cp saxon/build/saxon.jar saxon8.jar

saxon/build/saxon.jar:
	$(MAKE) -C saxon jar

clean:
	$(MAKE) -C saxon clean
	rm -rf *.jar
