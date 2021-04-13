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
OPBPMNXMLWriterVisitor >> namespace [
	^ 'semantic:'
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visit: aRootElement [
		writer 
			tag: self namespace, 'definitions'
			attributes: (Array "with: 'id' -> aRootElement uuid asString"
									 with: 'targetNamespace' -> 'https://openponk.org/' 
									 with: 'xmlns:xsi' -> 'http://www.w3.org/2001/XMLSchema-instance' 
									 with: 'xmlns:di' -> 'http://www.omg.org/spec/DD/20100524/DI'
									 with: 'xmlns:bpmndi' -> 'http://www.omg.org/spec/BPMN/20100524/DI'
									 with: 'xmlns:dc' -> 'http://www.omg.org/spec/DD/20100524/DC'
									 with: 'xmlns:semantic' -> 'http://www.omg.org/spec/BPMN/20100524/MODEL' ) 
			with: [
				writer 
					tag: self namespace, aRootElement printType
					attributes: (Array with: 'isExecutable' -> 'false'
											with: 'id' -> aRootElement uuid asString)
					with: 
						[aRootElement nodes do: [ :each | self visitElement: each ]]]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitElement: anElement [
	writer tag: self namespace, anElement printType 
			 attributes: (Array with: 'name' -> anElement name
									  with: 'id' -> anElement uuid asString)
			with: [(anElement isKindOf: OPBPMNPoolModel) ifTrue: [ anElement nodes do: [ :each | self visitElement: each ]]]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitFlow: aFlow [
	writer tag: self namespace, aFlow printType 
			 attributes: (Array with: 'sourceRef' -> aFlow source uuid asString
									 with: 'targetRef' -> aFlow target uuid asString
									  with: 'name' -> aFlow name
									  with: 'id' -> aFlow uuid asString)
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> writer [
	^ writer
]
