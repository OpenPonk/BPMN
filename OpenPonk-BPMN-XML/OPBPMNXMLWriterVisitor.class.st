Class {
	#name : #OPBPMNXMLWriterVisitor,
	#superclass : #Object,
	#instVars : [
		'writer',
		'allFlows'
	],
	#category : #'OpenPonk-BPMN-XML-Writer'
}

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> addFlow: aFlow [
	allFlows add: aFlow.
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> allFlows [
	^ allFlows
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> contents [
	^ writer contents
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> diagramNamespace [
	^ 'bpmndi:'
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> initialize [
	super initialize.
	writer := XMLWriter new.
	writer formatter: OPBPMNXMLPrettyWriter new.
	writer lineBreak: '&#10;'.
	writer xml encoding: 'UTF-8'.
	allFlows := OrderedCollection new
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
			with: [ self visitSemantic: aRootElement.
					  self visitDiagram: aRootElement]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitDiagram: aRootElement [
				writer 
					tag: self diagramNamespace, aRootElement printType
					attributes: (Array with: 'isExecutable' -> 'false'
											with: 'id' -> aRootElement uuid asString)
					"with: 
						[aRootElement nodes do: [ :each | self visitElement: each ].
						 self allFlows do: [ :each | self visitFlow: each]]"
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitElement: anElement [
	writer tag: self namespace, anElement printType 
			 attributes: (Array with: 'name' -> anElement name
									  with: 'id' -> anElement uuid asString)
			with: [((anElement isKindOf: OPBPMNPoolModel) | (anElement isKindOf: OPBPMNLaneModel)) 
						ifTrue: [ anElement nodes do: [ :each | self visitElement: each ]].
				anElement incoming do: [ :each | self visitFlowRef: each  inOut: 'incoming' ].
				anElement outgoing do: [ :each | self visitFlowRef: each  inOut: 'outgoing' ]]
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
OPBPMNXMLWriterVisitor >> visitFlowRef: aFlow inOut: inOut [
	(inOut = 'outgoing') ifTrue: [ self addFlow: aFlow ].
	writer tag: self namespace, inOut
			 with: aFlow source uuid asString
									
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitSemantic: aRootElement [
				writer 
					tag: self namespace, aRootElement printType
					attributes: (Array with: 'isExecutable' -> 'false'
											with: 'id' -> aRootElement uuid asString)
					with: 
						[aRootElement nodes do: [ :each | self visitElement: each ].
						 self allFlows do: [ :each | self visitFlow: each]]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> writer [
	^ writer
]
