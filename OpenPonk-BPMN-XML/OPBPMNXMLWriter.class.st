Class {
	#name : #OPBPMNXMLWriter,
	#superclass : #Object,
	#category : #'OpenPonk-BPMN-XML-Writer'
}

{ #category : #writing }
OPBPMNXMLWriter class >> write: anXML to: aStream [
	^ self new write: anXML to: aStream
]

{ #category : #writing }
OPBPMNXMLWriter class >> writeToString: anXML [
	^ String streamContents: [ :stream | self write: anXML to: stream ]
]

{ #category : #writing }
OPBPMNXMLWriter >> write: anXML to: aStream [
	| visitor |
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visit: anXML.
	aStream << visitor contents
]
