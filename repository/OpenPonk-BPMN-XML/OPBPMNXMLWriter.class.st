"
I provide the top-level API to serialize OpenPonk BPMN models into BPMN 2.0 compliant XML strings or streams.
"
Class {
	#name : 'OPBPMNXMLWriter',
	#superclass : 'Object',
	#category : 'OpenPonk-BPMN-XML-Writer',
	#package : 'OpenPonk-BPMN-XML',
	#tag : 'Writer'
}

{ #category : 'writing' }
OPBPMNXMLWriter class >> toString: anXML [

	| visitor |
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visit: anXML.
	^ visitor contents
]

{ #category : 'writing' }
OPBPMNXMLWriter class >> write: anXML toStream: aStream [

	aStream << (self toString: anXML)
]
