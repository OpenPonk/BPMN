Class {
	#name : #OPBPMNXMLReaderVisitor,
	#superclass : #XMLDOMVisitor,
	#instVars : [
		'mapping',
		'refIdMapping',
		'unresolved'
	],
	#category : #'OpenPonk-BPMN-XML-Reader'
}

{ #category : #factory }
OPBPMNXMLReaderVisitor >> attributeFor: aXMLAttribute [
	(self isReferenceAttribute: aXMLAttribute)
		ifTrue: [ ^ self referenceAttributeFor: aXMLAttribute ].
	^ self valueAttributeFor: aXMLAttribute
]

{ #category : #factory }
OPBPMNXMLReaderVisitor >> elementAt: aXMLElement [
	^ mapping at: aXMLElement
]

{ #category : #factory }
OPBPMNXMLReaderVisitor >> elementFor: aXMLElement [
	(self isValueElement: aXMLElement)
		ifTrue: [ ^ self valueElementFor: aXMLElement ].
	(self isReferenceElement: aXMLElement)
		ifTrue: [ ^ self referenceElementFor: aXMLElement ].
	^ self objectElementFor: aXMLElement
]

{ #category : #initialization }
OPBPMNXMLReaderVisitor >> initialize [
	super initialize.
	mapping := Dictionary new.
	refIdMapping := Dictionary new.
	unresolved := OrderedCollection new
]

{ #category : #factory }
OPBPMNXMLReaderVisitor >> resolveAll [
	unresolved do: #value
]

{ #category : #factory }
OPBPMNXMLReaderVisitor >> visitDocument: aDocument [
	self visit: aDocument root.
	self resolveAll.
	^ self elementAt: aDocument root
]
