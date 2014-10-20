Bridget's response to Adam's Team Pitch...

I think you are right that JackSON can serve a crucial role in the Perseids architecture.  I think it provides us with a new way to think about CITE collections, as collections of objects expressed in JSON or JSON-LD, and a means  for rapid prototyping of applications which work with data from these collections as well as for integration of contributions to these collections, and linked data annotations that reference items in them, with review and preservation workflows like those provided by Perseids.

But in order for it to play that role though I think a few requirements need to be met:

1. While use of the filesystem for storage of JSON-LD documents makes sense for quick roll-out of prototyping environments, and can be really really useful for working locally, I think for any sort of production use we must have the ability to use a No-SQL document/object database for storage.  This should be implemented in a way that is externally configurable for the JackSON server, so that it's just a matter of changing a configuration file to point it at a local file system or database server, and any client is completely unaffected by this change. I would like to see this tested with both AWS DynamoDB and an open source store like MongoDB.

		Adam: 
		Supporting both AWS DynamoDB and MongoDB will require significant development effort.
		What do we gain by supporting them?
			Performance?
				How many concurrent users can we realistically expect?
			Search?
				Search is possible by querying the SPARQL endpoint, is that not sufficient?
		
		Moving away from the filesystem will make a versioning system harder to develop.
		Git deals with plain text on a conventional filesystem rather elegantly.
		Who in our organization has experience with DynamoDB and MongoDB?

1. I think we should look at fully modeling CITE collections as collections of JSON documents. I think maybe a misunderstanding between us led to some extra headaches for you on this point, because while objects in CITE collections __may__ be able to represented partially or fully as triples, RDF may often not the best underlying representation of these objects. Ultimately they are simple objects of key/value pairs, with stable identifiers assigned to each object. Properties may be expressed in terms of controlled vocabulary, or simple strings. And a property may be a relationship to another CITE object (or other object identified by stable URI) but trying to exclusively represent them as RDF does not really make alot of sense, as you have noted, particularly when it comes to ordered collections.  I'd really like to see a conversion of the CITE TextInventory schema to a represenstation in JSON, and have these then be available as configuratoin files to JackSON, so that someone can express a CITE Collection in terms of the properties that make up objects in that collection in JSON, and then also store the objects themselves as JSON documents. If a collection object property included a linked data relationship, then these would be JSON-LD documents, otherwise just plain JSON.  We could then have these documents managed on Perseids just like any other document. When doing this though it would be important to understand and build off of the schema for CITE TextInventories and CITE Objects, to be sure that the JSON implementation is a true representation of the CITE protocol.  I think Anna may also already have made a start on this with the cite_collections_rails code, although I'm not sure.

		Adam: I understand that the CITE protocol defines an abstract model and not a specific RDF implementation.
		It's just that using multiple data formats and database technologies makes development exponentially harder.
		It's something to be avoided if possible.
		
		I'd like to see the CITE collection protocol modelled as JSON-LD documents too.
		I'd like to see all of our standards modelled as JSON-LD documents, waiting on the shelf for when they're needed.

1. Controlled vocabularies ... I really hate to see things like `http://localhost:4567/apps/elem/schema#mass` which reference a local server and port number. While I understand you are using this as an example, it immediately raises a warning flag to me. All ontologies used by the system should be external, and ideally reference stable URIs that are not tied to any single server instance. Further, wherever possible we should use standard ontologies and not be reinventing our own. Where we can't find a standard ontology and we need to build our own, we should be doing so in a stable namespace. For example, the verbs we needed to invent for the Art and Artifact CIDOC/RDF representation are under `http://data.perseus.org/rdfvocab/artifacts/`. We should be looking at adding any terminology that we absolutely have to invent either to that namespace, or maybe contributing it to the [LAWD](https://github.com/lawdi/LAWD) ontology instead. Even for a local prototyping setup, I think new terminology should be added under a pseudo-stable domain and not coupled in any way to the instance of the server that is running the code.

		Adam:  I agree.
		Using the proper ontology wasn't really on my mind.
		I understand I'm breaking some general linked-data principles with my examples,
		the big one being where that ontology is defined.
		I just wanted to make sure the system worked in the abstract.
		
		This is tagntially related, but I believe there is danger in developing 
		an ontology decoupled from a working application.
		
		The default behavior of developers is to just build
		an internally consistent data-model for the application, and worry about standards later.
		
		The default behavior of researchers seems to be to define a standard data-model and 
		let developers worry about implementing it later. ;)
		
		I'm not saying that's how things should be but that's how things are, from my point-of-view.
		
		Adhering to someone else's standard requires much more effort than adhering to your own.
		People who create the ontology have to communicate the purpose and proper application of it,
		and the people implementing it have to internalize that ontology to build something new with it.
		
		Having a rapid prototyping system like JackSON can really help in this regard.
		A JSON-LD template is all that's needed to build a working data-model with JackSON.
		
		Giving a new developer a JSON-LD template to fill-in, Mad-Libs style, and a validation file
		will produce better outcomes than giving them an OWL document and hoping they can apply it properly.
		I'm certain of that.

1. Re Git and Versioning: I'd like us all to put some more thought into how versioning should work, how this might interact with SoSOL as well as directly with a Git back-end, and how this interoperates with review and publication workflows. Currently SoSOL is the means by which we support a review workflow for items and also serves as the intermediary to git. In the short term we will want to continue to be able to leverage it for that, but in the long term we may well want to support other workflows that interact more directly with Git and avoid the overhead of Perseids. I think any tool we develop should be built with both of these use cases in mind. This is related to the question of how to identify finely grained versions for micro-publications, whether we want to extend the CITE protocol for this, etc. as I raised in [my document on that topic](https://docs.google.com/document/d/1765E-StEK-Fv0yjk05pprMVdaVW8F-oc8dl2T0yhj20/edit). I really think this is something we should work together as a team to identify a vision and architecture for and not proceed under separate paths to implementations.

