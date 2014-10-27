# Templates
Grab useful JSON-LD templates...

	git clone https://github.com/PerseusDL/CITE-JSON-LD templates/cite

... now CITE protocol JSON-LD is available in **templates/cite**.

## JSON-LD test data from a template
	rake data:random[ template, generator, n, dir ]

	rake data:random['cite/templates/cite_collection.json.erb','cite/generators/cite_collection.rb',10,'test']

This command grabs the specified .erb **template** in __template/__**template** and produces **n** JSON-LD files in __data/__**dir** using values created by **generator**

## Testing workflow
1. Use a fresh instance of JackSON
2. Generate test JSON-LD files

		rake data:fake['cite/templates/cite_collection.json.erb','cite/generators/cite_collection.rb',1000,'test']

3. Convert all test JSON-LD files to RDF

		rake triple:make

4. Check Fuseki triples

		http://localhost:4321/ds/query?query=select+%3Fs+%3Fp+%3Fo%0D%0Awhere+%7B+%3Fs+%3Fp+%3Fo+%7D&output=text&stylesheet=
	
5. Wipeout all existing data...

		rake data:destroy

6. Loop-back to step 2