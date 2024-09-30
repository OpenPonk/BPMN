Class {
	#name : 'OPBPMNXMLReader',
	#superclass : 'Object',
	#category : 'OpenPonk-BPMN-XML-Reader',
	#package : 'OpenPonk-BPMN-XML',
	#tag : 'Reader'
}

{ #category : 'instance creation' }
OPBPMNXMLReader class >> read: aStream mapping: aMapping [
	aMapping at: 'result' put: aStream contents.
	^ (self readFromMapping: aMapping) at: 'result'
]

{ #category : 'instance creation' }
OPBPMNXMLReader class >> readFrom: aStream [
	^ self new readFrom: aStream
]

{ #category : 'instance creation' }
OPBPMNXMLReader class >> readFromMapping: aMapping [
	"aMapping is a Dictionary of HREF URI -> XMI contents"

	^ self new readFromMapping: aMapping
]

{ #category : 'instance creation' }
OPBPMNXMLReader >> read: aStream mapping: aMapping [
	aMapping at: 'result' put: aStream contents.
	^ (self readFromMapping: aMapping) at: 'result'
]

{ #category : 'instance creation' }
OPBPMNXMLReader >> readFrom: aStream [
	| dom root |
	dom := XMLDOMParser parse: aStream usingNamespaces: false.
	root := OPBPMNXMLReaderVisitor new visitDocument: dom.
	^ root
]

{ #category : 'instance creation' }
OPBPMNXMLReader >> readFromMapping: aMapping [
	| graphs |
	graphs := OrderedDictionary new.
	aMapping keysAndValuesDo: [ :key :value | graphs at: key put: (self readFrom: value) ].
	graphs valuesDo: [ :root | self resolveHrefsIn: root with: graphs ].
	^ graphs
]
