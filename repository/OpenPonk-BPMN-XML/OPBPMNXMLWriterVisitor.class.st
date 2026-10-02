"
I am a visitor that traverses the OpenPonk BPMN domain model (including nodes, events, sequence flows, participants, and diagram definitions) and orchestrates the generation of the corresponding BPMN XML structure.
"
Class {
	#name : 'OPBPMNXMLWriterVisitor',
	#superclass : 'Object',
	#instVars : [
		'writer',
		'allFlows',
		'allMessageFlows',
		'namespace'
	],
	#category : 'OpenPonk-BPMN-XML-Writer',
	#package : 'OpenPonk-BPMN-XML',
	#tag : 'Writer'
}

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> addFlow: aFlow [
	allFlows add: aFlow.
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> addMessageFlow: aFlow [
	allMessageFlows add: aFlow.
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> allFlows [
	^ allFlows
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> allMessageFlows [
	^ allMessageFlows
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> contents [
	^ writer contents
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> diagramNamespace [
	^ 'bpmndi:'
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> initialize [
	super initialize.
	writer := XMLWriter new.
	writer formatter: OPBPMNXMLPrettyWriter new.
	writer lineBreak: '&#10;'.
	writer xml encoding: 'UTF-8'.
	namespace := 'bpmn:'.
	allFlows := OrderedCollection new.
	allMessageFlows := OrderedCollection new
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> namespace [
	^ namespace
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> namespace: aValue [
	namespace := aValue
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> removeAllFlows [
	allFlows removeAll.
]

{ #category : 'visiting' }
OPBPMNXMLWriterVisitor >> removeFlow: aFlow [
	aFlow ifNotNil: [ allFlows remove: aFlow ifAbsent: [ nil ] ]
]

{ #category : 'visiting' }
OPBPMNXMLWriterVisitor >> visit: aRootElement [
	| model diagramRoot |
	(aRootElement respondsTo: #model)
		ifTrue: [
			model := aRootElement model.
			diagramRoot := aRootElement ]
		ifFalse: [
			model := aRootElement.
			diagramRoot := nil ].
	writer
		tag: self namespace , 'definitions'
		attributes: {
			'targetNamespace' -> 'https://openponk.org/' .
			'xmlns:xsi' -> 'http://www.w3.org/2001/XMLSchema-instance' .
			'xmlns:di' -> 'http://www.omg.org/spec/DD/20100524/DI' .
			'xmlns:bpmndi' -> 'http://www.omg.org/spec/BPMN/20100524/DI' .
			'xmlns:dc' -> 'http://www.omg.org/spec/DD/20100524/DC' .
			'xmlns:semantic' -> 'http://www.omg.org/spec/BPMN/20100524/MODEL' .
			'xmlns:bpmn' -> 'http://www.omg.org/spec/BPMN/20100524/MODEL' }
		with: [
			self visitSemantic: model.
			diagramRoot ifNotNil: [ self visitDiagram: diagramRoot ] ]
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> visitDiagram: aRootElement [
"<bpmndi:BPMNDiagram id=""BPMNDiagram_0e5130ce-1e7d-0d00-a4c5-09a30e3ea2c6"" 
							name=""New Project"" resolution=""96.0"">
        <bpmndi:BPMNPlane bpmnElement=""process_0e5130ce-1e7d-0d00-a4c5-09a30e3ea2c6"">"
	writer
		tag: self diagramNamespace , 'BPMNDiagram'
		attributes:
			(Array
				with: 'id' -> ('BPMNDiagram_' , aRootElement model uuid asString)
				with: 'name' -> aRootElement model name
				with: 'resolution' -> '96.0')
		with: [ writer
				tag: self diagramNamespace , 'BPMNPlane'
				attributes:
					(Array
						with:
							'bpmnElement'
								-> (aRootElement model printType , '_' , aRootElement model uuid asString))
				with: [ aRootElement controllers
						do: [ :each | self visitDiagramElement: each ] ] ]
]

{ #category : 'visiting' }
OPBPMNXMLWriterVisitor >> visitDiagramElement: anElement [
	(anElement isKindOf: OPBPMNEdgeController)
		ifTrue: [ self visitDiagramFlow: anElement ]
		ifFalse: [
			(anElement isKindOf: OPBPMNPoolController)
				ifTrue: [ self visitDiagramParticipant: anElement ]
				ifFalse: [
					writer
						tag: self diagramNamespace , 'BPMNShape'
						attributes: (Array with: 'bpmnElement'
								 ->
								 (anElement model printIdType
								  , anElement model uuid asString))
						with: [
							writer tag: 'dc:Bounds' attributes: (Array
										 with:
											 'height' -> anElement diagramElement height asString
										 with: 'width' -> anElement diagramElement width asString
										 with: 'x' -> (anElement diagramElement position x
												  - (anElement diagramElement width / 2.0)) asString
										 with: 'y' -> (anElement diagramElement position y
												  - (anElement diagramElement height / 2.0)) asString).
							writer tag: self diagramNamespace , 'BPMNLabel' ] ] ]
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> visitDiagramFlow: anElement [
	"<bpmndi:BPMNEdge bpmnElement=""_6-0e5130ce-1e7d-0d00-a4cd-8bba0e3ea2c6"">
     <di:waypoint x=""-4.9995000499949045"" y=""-129.98700129987003""/>
     <di:waypoint x=""105.98940105989404"" y=""-129.98700129987""/>
 </bpmndi:BPMNEdge>"

	writer
		tag: self diagramNamespace , 'BPMNEdge'
		attributes: (Array with: 'bpmnElement'
				 -> (anElement model printIdType , anElement model uuid asString))
		with: [
			writer tag: 'di:waypoint' attributes: (Array
					 with: 'x' -> anElement source diagramElement position x asString
					 with: 'y' -> anElement source diagramElement position y asString).
			writer tag: 'di:waypoint' attributes: (Array
					 with: 'x' -> anElement target diagramElement position x asString
					 with: 'y' -> anElement target diagramElement position y asString) ]
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> visitDiagramParticipant: anElement [

	writer
		tag: self diagramNamespace , 'BPMNShape'
		attributes: (Array with:
				 'bpmnElement' -> ('participant_' , anElement model uuid asString))
		with: [
			writer tag: 'dc:Bounds' attributes: (Array
					 with: 'height' -> anElement diagramElement height asString
					 with: 'width' -> anElement diagramElement width asString
					 with: 'x' -> (anElement diagramElement position x
						  - (anElement diagramElement width / 2.0)) asString
					 with: 'y' -> (anElement diagramElement position y
						  - (anElement diagramElement height / 2.0)) asString).
			writer tag: self diagramNamespace , 'BPMNLabel' ]
]

{ #category : 'visiting' }
OPBPMNXMLWriterVisitor >> visitElement: anElement [
	(anElement isKindOf: OPBPMNActivityModel)
		ifTrue: [ ^ self visitElementActivity: anElement ].
	(anElement isKindOf: OPBPMNBoundaryEventModel)
		ifTrue: [ ^ self visitElementBoundaryEvent: anElement ].
	(anElement isKindOf: OPBPMNEventModel)
		ifTrue: [ ^ self visitElementEvent: anElement ].
	(anElement isKindOf: OPBPMNAnnotationModel)
		ifTrue: [ ^ self visitElementAnnotation: anElement ].
	((anElement isKindOf: OPBPMNAssociationModel) or: [ anElement isKindOf: OPBPMNDataFlowModel ])
		ifTrue: [ ^ self visitElementAssociation: anElement ].
	(anElement isKindOf: OPBPMNSubProcessModel)
		ifTrue: [ ^ self visitElementSubProcess: anElement ].

	writer
		tag: self namespace , anElement printType
		attributes: (Array
				 with: 'name' -> (anElement name ifNil: [ '' ])
				 with:
				 'id' -> (anElement printIdType , anElement uuid asString))
		with: [
			(anElement isKindOf: OPBPMNPoolModel) ifTrue: [
				| poolElements poolAssociations boundaryEvents |
				poolElements := anElement hasLanes
					ifTrue: [
						| collected |
						self visitLaneSet: anElement.
						collected := OrderedCollection new.
						anElement lanes do: [ :eachLane |
							collected addAll: eachLane elements ].
						collected addAll: (anElement elements reject: [ :each | each isKindOf: OPBPMNLaneModel ]).
						collected ]
					ifFalse: [ anElement nodes ].
				boundaryEvents := (poolElements flatCollect: [ :each |
					(each isKindOf: OPBPMNSubProcessModel)
						ifTrue: [ each elements select: [ :subElem | (subElem isKindOf: OPBPMNBoundaryEventModel) and: [ subElem owner = each ] ] ]
						ifFalse: [ #( ) ] ]) asSet.
				poolElements do: [ :each | self visitElement: each ].
				boundaryEvents do: [ :each | self visitElement: each ].
				poolAssociations := (poolElements flatCollect: [ :each |
					| assocs |
					assocs := OrderedCollection new.
					(each respondsTo: #associations) ifTrue: [ assocs addAll: (each associations ifNil: [ #( ) ]) ].
					(each respondsTo: #flows) ifTrue: [
						assocs addAll: ((each flows ifNil: [ #( ) ]) select: [ :f |
							(f isKindOf: OPBPMNAssociationModel) or: [ f isKindOf: OPBPMNDataFlowModel ] ]) ].
					assocs ]) asSet.
				poolAssociations do: [ :each | self visitElement: each ].
				self allFlows do: [ :each |
					self visitFlow: each type: 'sequenceFlow' ].
				self allFlows do: [ :each | self removeFlow: each ] ].
			((anElement isKindOf: OPBPMNSemanticNodeModel) and: [ (anElement isKindOf: OPBPMNPoolModel) not ]) ifTrue: [
				(anElement incoming select: [ :each | each isKindOf: OPBPMNFlowModel ])
					do: [ :each | self visitFlowRef: each inOut: 'incoming' ].
				(anElement outgoing select: [ :each | each isKindOf: OPBPMNFlowModel ])
					do: [ :each | self visitFlowRef: each inOut: 'outgoing' ] ] ]
]

{ #category : 'visiting' }
OPBPMNXMLWriterVisitor >> visitElementActivity: anElement [
	| attributes |
	attributes := OrderedCollection new.
	attributes add: 'name' -> (anElement name ifNil: [ '' ]).
	attributes add: 'id' -> (anElement printIdType , anElement uuid asString).
	(anElement executableAttribute isNotNil and: [ anElement executableAttribute isNotEmpty ]) ifTrue: [
		attributes add: anElement executableAttribute -> (anElement executableAttributeValue ifNil: [ '' ]) ].
	writer
		tag: self namespace , anElement printType
		attributes: attributes asArray
		with: [
			(anElement incoming select: [ :each | each isKindOf: OPBPMNFlowModel ])
				do: [ :each | self visitFlowRef: each inOut: 'incoming' ].
			(anElement outgoing select: [ :each | each isKindOf: OPBPMNFlowModel ])
				do: [ :each | self visitFlowRef: each inOut: 'outgoing' ] ]
]

{ #category : 'visiting' }
OPBPMNXMLWriterVisitor >> visitElementAnnotation: anAnnotation [
	writer
		tag: self namespace , anAnnotation printType
		attributes: (Array with: 'id' -> (anAnnotation printIdType , anAnnotation uuid asString))
		with: [
			writer
				tag: self namespace , 'text'
				with: (anAnnotation text ifNil: [ '' ]) ]
]

{ #category : 'visiting' }
OPBPMNXMLWriterVisitor >> visitElementAssociation: anAssociation [
	| attributes |
	attributes := OrderedCollection new.
	attributes add: 'id' -> (anAssociation printIdType , anAssociation uuid asString).
	anAssociation source ifNotNil: [ :sourceModel |
		attributes add: 'sourceRef' -> (sourceModel printIdType , sourceModel uuid asString) ].
	anAssociation target ifNotNil: [ :targetModel |
		attributes add: 'targetRef' -> (targetModel printIdType , targetModel uuid asString) ].
	(anAssociation respondsTo: #associationDirection) ifTrue: [
		anAssociation associationDirection ifNotNil: [ :direction |
			attributes add: 'associationDirection' -> direction asString ] ].
	writer
		tag: self namespace , anAssociation printType
		attributes: attributes asArray
]

{ #category : 'visiting' }
OPBPMNXMLWriterVisitor >> visitElementBoundaryEvent: aBoundaryEvent [
	| attributes host |
	attributes := OrderedCollection new.
	attributes add: 'id' -> (aBoundaryEvent printIdType , aBoundaryEvent uuid asString).
	attributes add: 'name' -> (aBoundaryEvent name ifNil: [ '' ]).
	host := aBoundaryEvent owner.
	host ifNotNil: [
		attributes add: 'attachedToRef' -> (host printIdType , host uuid asString) ].
	(aBoundaryEvent isNonInterrupting ifNil: [ false ]) ifTrue: [
		attributes add: 'cancelActivity' -> 'false' ].
	writer
		tag: self namespace , aBoundaryEvent printType
		attributes: attributes asArray
		with: [
			(aBoundaryEvent incoming select: [ :each | each isKindOf: OPBPMNFlowModel ])
				do: [ :each | self visitFlowRef: each inOut: 'incoming' ].
			(aBoundaryEvent outgoing select: [ :each | each isKindOf: OPBPMNFlowModel ])
				do: [ :each | self visitFlowRef: each inOut: 'outgoing' ].
			aBoundaryEvent type = OPBPMNNodeType Timer ifTrue: [
				self visitElementEventTimer: aBoundaryEvent ] ]
]

{ #category : 'visiting' }
OPBPMNXMLWriterVisitor >> visitElementEvent: anElement [
	| attributes |
	attributes := OrderedCollection new.
	attributes add: 'name' -> (anElement name ifNil: [ '' ]).
	attributes add: 'id' -> (anElement printIdType , anElement uuid asString).
	(anElement executableAttribute isNotNil and: [ anElement executableAttribute isNotEmpty ]) ifTrue: [
		attributes add: anElement executableAttribute -> (anElement executableAttributeValue ifNil: [ '' ]) ].
	writer
		tag: self namespace , anElement printType
		attributes: attributes asArray
		with: [
			(anElement incoming select: [ :each | each isKindOf: OPBPMNFlowModel ])
				do: [ :each | self visitFlowRef: each inOut: 'incoming' ].
			(anElement outgoing select: [ :each | each isKindOf: OPBPMNFlowModel ])
				do: [ :each | self visitFlowRef: each inOut: 'outgoing' ].
			anElement type = OPBPMNNodeType Timer ifTrue: [
				self visitElementEventTimer: anElement ] ]
]

{ #category : 'visiting' }
OPBPMNXMLWriterVisitor >> visitElementEventTimer: anElement [
	| hasExpression timerTypeValue |
	timerTypeValue := (anElement respondsTo: #timerType)
		ifTrue: [ anElement timerType ]
		ifFalse: [ nil ].
	hasExpression := timerTypeValue isNotNil and: [
		timerTypeValue ~= #none and: [
			timerTypeValue isNotEmpty ] ].
	writer
		tag: self namespace , 'timerEventDefinition'
		attributes: (Array with:
			'id' -> ('timerEventDefinition_' , anElement uuid asString))
		with: [
			hasExpression ifTrue: [
				writer
					tag: self namespace , timerTypeValue asString
					attributes: (Array with: 'xsi:type' -> 'semantic:tFormalExpression')
					with: ((anElement respondsTo: #timerValue)
						ifTrue: [ anElement timerValue ifNil: [ '' ] ]
						ifFalse: [ '' ]) ] ]
]

{ #category : 'visiting' }
OPBPMNXMLWriterVisitor >> visitElementSubProcess: aSubProcess [
	| innerElements innerFlows |
	innerElements := aSubProcess elements reject: [ :each |
		(each isKindOf: OPBPMNEdgeModel) or: [
			(each isKindOf: OPBPMNBoundaryEventModel) and: [ each owner = aSubProcess ] ] ].
	writer
		tag: self namespace , aSubProcess printType
		attributes: (Array
				 with: 'name' -> (aSubProcess name ifNil: [ '' ])
				 with: 'id' -> (aSubProcess printIdType , aSubProcess uuid asString))
		with: [
			(aSubProcess incoming select: [ :each | each isKindOf: OPBPMNFlowModel ])
				do: [ :each | self visitFlowRef: each inOut: 'incoming' ].
			(aSubProcess outgoing select: [ :each | each isKindOf: OPBPMNFlowModel ])
				do: [ :each | self visitFlowRef: each inOut: 'outgoing' ].
			innerElements do: [ :each |
				self visitElement: each ].
			innerFlows := (aSubProcess elements select: [ :each | each isKindOf: OPBPMNEdgeModel ]) asSet.
			innerFlows addAll: (self allFlows select: [ :eachFlow |
				(innerElements includes: eachFlow source) and: [ innerElements includes: eachFlow target ] ]).
			innerFlows do: [ :each |
				self visitFlow: each type: 'sequenceFlow'.
				self removeFlow: each ] ]
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> visitFlow: aFlow type: aType [
"<semantic:sequenceFlow sourceRef=""_6-0e5130ce-1e7d-0d00-a4c6-bd810e3ea2c6"" targetRef=""_6-0e5130ce-1e7d-0d00-a4c7-8c720e3ea2c6"" name="" id=""_6-0e5130ce-1e7d-0d00-a4cb-427f0e3ea2c6""/>"
	aType = aFlow printType
		ifTrue: [ writer
				tag: self namespace , aFlow printType
				attributes:
					(Array
						with: 'sourceRef' -> (aFlow printIdType , aFlow source uuid asString)
						with: 'targetRef' -> (aFlow printIdType , aFlow target uuid asString)
						with: 'name' -> aFlow name
						with: 'id' -> (aFlow printIdType , aFlow uuid asString)) ]
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> visitFlowRef: aFlow inOut: inOut [
"<bpmn:outgoing>_6-0e5130ce-1e7d-0d00-a4c6-bd810e3ea2c6</bpmn:outgoing> or"
"<bpmn:incoming>_6-0e5130ce-1e7d-0d00-a4c7-8c720e3ea2c6</bpmn:incoming>"
	inOut = 'outgoing'
		ifTrue: [ aFlow printType = 'messageFlow'
				ifTrue: [ self addMessageFlow: aFlow ]
				ifFalse: [ self addFlow: aFlow ] ].
	writer
		tag: self namespace , inOut
		with: aFlow printIdType , aFlow uuid asString
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> visitLaneSet: aPool [
	writer
		tag: self namespace , 'laneSet'
		attributes: (Array with: 'id' -> ('laneSet_' , aPool uuid asString))
		with: [
			aPool lanes do: [ :eachLane |
				writer
					tag: self namespace , 'lane'
					attributes: (Array
						with: 'name' -> (eachLane name ifNil: [ '' ])
						with: 'id' -> (eachLane printIdType , eachLane uuid asString))
					with: [
						eachLane flowNodes do: [ :eachNode |
							writer
								tag: self namespace , 'flowNodeRef'
								with: eachNode printIdType , eachNode uuid asString ] ] ] ]
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> visitParticipantRef: anElement [
"<semantic:participant id=""participant_a96e59ae-477d-0d00-a841-8fa10a66547e"" 							 							processRef=""_6-a96e59ae-477d-0d00-a841-8fa10a66547e""/>"
	writer
		tag: self namespace , 'participant'
		attributes:
			(Array
				with: 'id' -> ('participant_' , anElement uuid asString)
				with: 'processRef' -> (anElement printIdType , anElement uuid asString))
]

{ #category : 'visiting' }
OPBPMNXMLWriterVisitor >> visitSemantic: aRootElement [
	| counter allNodes |
	counter := 0.
	allNodes := aRootElement nodes.
	allNodes do: [ :each |
		(each isKindOf: OPBPMNPoolModel)
			ifTrue: [ counter := counter + 1 ] ].
	counter = 0
		ifTrue: [
			writer
				tag: self namespace , aRootElement printType
				attributes: (Array
						 with: 'isExecutable' -> aRootElement isExecutable asString
						 with: 'id' -> (aRootElement printType , '_' , aRootElement uuid asString))
				with: [
					aRootElement nodes do: [ :each | self visitElement: each ].
					self allFlows do: [ :each | self visitFlow: each type: 'sequenceFlow' ] ] ]
		ifFalse: [
			| msgFlows |
			msgFlows := (allNodes flatCollect: [ :eachNode |
				(eachNode respondsTo: #flows)
					ifTrue: [ eachNode flows select: [ :f | f isKindOf: OPBPMNMessageFlowModel ] ]
					ifFalse: [ #( ) ] ]) asSet.
			msgFlows do: [ :each | self addMessageFlow: each ].
			allNodes do: [ :each | self visitElement: each ].
			writer
				tag: self namespace , 'collaboration'
				attributes: (Array
						 with: 'id' -> (aRootElement printType , '_' , aRootElement uuid asString))
				with: [
					allNodes do: [ :each |
						(each isKindOf: OPBPMNPoolModel)
							ifTrue: [ self visitParticipantRef: each ] ].
					self allMessageFlows
						do: [ :each | self visitFlow: each type: 'messageFlow' ] ] ]
]

{ #category : 'initialization' }
OPBPMNXMLWriterVisitor >> writer [
	^ writer
]
