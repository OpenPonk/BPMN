Class {
	#name : #OPBPMNXMLObjectElement,
	#superclass : #OPBPMNXMLElement,
	#instVars : [
		'containedItems'
	],
	#category : #'OpenPonk-BPMN-XML-DOM'
}

{ #category : #visiting }
OPBPMNXMLObjectElement >> accept: aVisitor [
	aVisitor visitObjectElement: self
]

{ #category : #initialization }
OPBPMNXMLObjectElement >> initialize [
	super initialize.
	containedItems := OrderedCollection new
]
