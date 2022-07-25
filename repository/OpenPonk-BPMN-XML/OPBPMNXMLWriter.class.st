Class {
	#name : #OPBPMNXMLWriter,
	#superclass : #Object,
	#category : #'OpenPonk-BPMN-XML-Writer'
}

{ #category : #writing }
OPBPMNXMLWriter class >> toString: anXML [

	| visitor |
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visit: anXML.
	^ visitor contents
]

{ #category : #writing }
OPBPMNXMLWriter class >> write: anXML toStream: aStream [

	aStream << (self toString: anXML)
]
