Class {
	#name : #OPBPMNXMLWriterVisitor,
	#superclass : #Object,
	#instVars : [
		'writer'
	],
	#category : #'OpenPonk-BPMN-XML-Writer'
}

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> contents [
	^ writer contents
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> initialize [
	super initialize.
	writer := XMLWriter new.
	writer formatter: OPBPMNXMLPrettyWriter new.
	writer lineBreak: '&#10;'.
	writer xml encoding: 'UTF-8'
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visit: anElement [
	writer tag: 'semantic:', anElement printType with: anElement name
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> writer [
	^ writer
]
