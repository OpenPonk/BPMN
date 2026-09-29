"
I am a DOM visitor that traverses a parsed BPMN XML document tree. I map XML elements to OpenPonk BPMN model objects and resolve reference IDs to reconstruct the model graph.
"
Class {
	#name : 'OPBPMNXMLReaderVisitor',
	#superclass : 'XMLDOMVisitor',
	#instVars : [
		'mapping',
		'refIdMapping',
		'unresolved'
	],
	#category : 'OpenPonk-BPMN-XML-Reader',
	#package : 'OpenPonk-BPMN-XML',
	#tag : 'Reader'
}

{ #category : 'factory' }
OPBPMNXMLReaderVisitor >> attributeFor: aXMLAttribute [
	(self isReferenceAttribute: aXMLAttribute)
		ifTrue: [ ^ self referenceAttributeFor: aXMLAttribute ].
	^ self valueAttributeFor: aXMLAttribute
]

{ #category : 'factory' }
OPBPMNXMLReaderVisitor >> elementAt: aXMLElement [
	^ mapping at: aXMLElement
]

{ #category : 'factory' }
OPBPMNXMLReaderVisitor >> elementFor: aXMLElement [
	(self isValueElement: aXMLElement)
		ifTrue: [ ^ self valueElementFor: aXMLElement ].
	(self isReferenceElement: aXMLElement)
		ifTrue: [ ^ self referenceElementFor: aXMLElement ].
	^ self objectElementFor: aXMLElement
]

{ #category : 'initialization' }
OPBPMNXMLReaderVisitor >> initialize [
	super initialize.
	mapping := Dictionary new.
	refIdMapping := Dictionary new.
	unresolved := OrderedCollection new
]

{ #category : 'factory' }
OPBPMNXMLReaderVisitor >> resolveAll [
	unresolved do: #value
]

{ #category : 'visiting' }
OPBPMNXMLReaderVisitor >> visitDocument: aDocument [
	self visit: aDocument root.
	self resolveAll.
	^ self elementAt: aDocument root
]
