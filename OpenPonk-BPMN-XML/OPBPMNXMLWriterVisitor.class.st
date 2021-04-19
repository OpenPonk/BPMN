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
OPBPMNXMLWriterVisitor >> removeAllFlows [
	allFlows removeAll.
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> removeFlow: aFlow [
	allFlows remove: aFlow.
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
			with: [ self visitSemantic: aRootElement model.
					  self visitDiagram: aRootElement]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitDiagram: aRootElement [
				writer 
					tag: self diagramNamespace, 'BPMNDiagram'
					attributes: (Array with: 'id' -> ('BPMNDiagram_', aRootElement model uuid asString)
											with: 'name' -> aRootElement model name
											with: 'resolution' -> '96.00000267028808')
					with: 
						[ writer tag: self diagramNamespace, 'BPMNPlane'
						 			attributes: (Array with: 'bpmnElement' -> (aRootElement model printType, '_', aRootElement model uuid asString))
									with: [ aRootElement controllers do: [ :each | self visitDiagramElement: each ]]]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitDiagramElement: anElement [
	(anElement isKindOf: OPBPMNNodeController) 
	ifTrue: [  
		(anElement isKindOf: OPBPMNPoolController) 
		ifTrue: [ self visitDiagramParticipant: anElement ] 
		ifFalse: [  
	writer tag: self diagramNamespace, 'BPMNShape'
			 attributes: (Array with: 'bpmnElement' -> (anElement model printIdType, anElement model uuid asString))
			 with: [ writer tag: 'dc:Bounds'
								attributes: (Array with: 'height' -> anElement figure height asString
														 with: 'width' -> anElement figure width asString
														 with: 'x' -> (anElement figure position x 
																			- ((anElement figure width) / 2.0)) asString
														 with: 'y' -> (anElement figure position y 
																			- ((anElement figure height) / 2.0)) asString).
														writer tag: self diagramNamespace, 'BPMNLabel']]]
	ifFalse: [ self visitDiagramFlow: anElement ] 
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitDiagramFlow: anElement [
	writer tag: self diagramNamespace, 'BPMNEdge'
			 attributes: (Array with: 'bpmnElement' -> (anElement model printIdType, anElement model uuid asString))
			 with: [ writer tag: 'di:waypoint'
								attributes: (Array with: 'x' -> (anElement source figure position x) asString
														 with: 'y' -> (anElement source figure position y) asString).
						writer tag: 'di:waypoint'
								attributes: (Array with: 'x' -> (anElement target figure position x) asString
														 with: 'y' -> (anElement target figure position y) asString )]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitDiagramParticipant: anElement [
	writer tag: self diagramNamespace, 'BPMNShape'
			 attributes: (Array with: 'bpmnElement' -> ('participant_', anElement model uuid asString))
			 with: [ writer tag: 'dc:Bounds'
								attributes: (Array with: 'height' -> anElement figure height asString
														 with: 'width' -> anElement figure width asString
														 with: 'x' -> (anElement figure position x 
																			- ((anElement figure width) / 2.0)) asString
														 with: 'y' -> (anElement figure position y 
																			- ((anElement figure height) / 2.0)) asString).
														writer tag: self diagramNamespace, 'BPMNLabel']
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitElement: anElement [
	writer tag: self namespace, anElement printType 
			 attributes: (Array with: 'name' -> anElement name
									  with: 'id' -> (anElement printIdType, anElement uuid asString))
			with: [((anElement isKindOf: OPBPMNPoolModel) | (anElement isKindOf: OPBPMNLaneModel)) 
						ifTrue: [ anElement nodes do: [ :each | self visitElement: each ]. 
									self allFlows do: [ :each | self visitFlow: each ].
									self allFlows do: [ :each | self removeFlow: each ] ].
				anElement incoming do: [ :each | self visitFlowRef: each  inOut: 'incoming' ].
				anElement outgoing do: [ :each | self visitFlowRef: each  inOut: 'outgoing' ]]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitFlow: aFlow [
	writer tag: self namespace, aFlow printType 
			 attributes: (Array with: 'sourceRef' -> (aFlow printIdType, aFlow source uuid asString)
									 with: 'targetRef' -> (aFlow printIdType, aFlow target uuid asString)
									  with: 'name' -> aFlow name
									  with: 'id' -> (aFlow printIdType, aFlow uuid asString))
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitFlowRef: aFlow inOut: inOut [
	(inOut = 'outgoing') ifTrue: [ self addFlow: aFlow ].
	writer tag: self namespace, inOut
			 with: (aFlow printIdType, aFlow source uuid asString)
									
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitParticipantRef: anElement [ 
	writer tag: self namespace, 'participant'
			 attributes: (Array with: 'id' -> ('participant_', anElement uuid asString)
										with: 'processRef' -> (anElement printIdType, anElement uuid asString))
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitSemantic: aRootElement [
	| counter |
	counter := 0.
	aRootElement nodes
		do: [ :each | 
			(each isKindOf: OPBPMNPoolModel)
				ifTrue: [ counter := counter + 1 ] ].
	counter = 0
		ifTrue: [ writer
				tag: self namespace , aRootElement printType
				attributes:
					(Array
						with: 'isExecutable' -> 'false'
						with: 'id' -> (aRootElement printType , '_' , aRootElement uuid asString))
				with: [ aRootElement nodes do: [ :each | self visitElement: each ].
					self allFlows do: [ :each | self visitFlow: each ] ] ]
		ifFalse: [ writer
				tag: self namespace , 'collaboration'
				attributes:
					(Array with: 'id' -> (aRootElement printType , '_' , aRootElement uuid asString))
				with: [ aRootElement nodes
						do: [ :each | 
							(each isKindOf: OPBPMNPoolModel)
								ifTrue: [ self visitParticipantRef: each ] ] ].
			aRootElement nodes do: [ :each | self visitElement: each ] ]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> writer [
	^ writer
]
