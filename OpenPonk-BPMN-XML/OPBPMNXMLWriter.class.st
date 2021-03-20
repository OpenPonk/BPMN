Class {
	#name : #OPBPMNXMLWriter,
	#superclass : #Object,
	#category : #'OpenPonk-BPMN-XML-Writer'
}

{ #category : #writing }
OPBPMNXMLWriter >> write: anXML to: aStream [
	| visitor |
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visit: anXML.
	aStream << visitor contents
]
