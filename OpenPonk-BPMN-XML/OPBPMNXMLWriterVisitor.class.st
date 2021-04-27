Class {
	#name : #OPBPMNXMLWriterVisitor,
	#superclass : #Object,
	#instVars : [
		'writer',
		'allFlows',
		'allMessageFlows',
		'namespace'
	],
	#category : #'OpenPonk-BPMN-XML-Writer'
}

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> addFlow: aFlow [
	allFlows add: aFlow.
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> addMessageFlow: aFlow [
	allMessageFlows add: aFlow.
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> allFlows [
	^ allFlows
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> allMessageFlows [
	^ allMessageFlows
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
	namespace := 'bpmn:'.
	allFlows := OrderedCollection new.
	allMessageFlows := OrderedCollection new
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> namespace [
	^ namespace
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> namespace: aValue [
	namespace := aValue
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> removeAllFlows [
	allFlows removeAll.
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> removeFlow: aFlow [
	aFlow ifNotNil: [ allFlows remove: aFlow ]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visit: aRootElement [
		writer 
			tag: self namespace, 'definitions'
			attributes: (Array  "with: 'targetNamespace' -> 'https://openponk.org/' "
									 with: 'xmlns:xsi' -> 'http://www.w3.org/2001/XMLSchema-instance' 
									 with: 'xmlns:di' -> 'http://www.omg.org/spec/DD/20100524/DI'
									 with: 'xmlns:bpmndi' -> 'http://www.omg.org/spec/BPMN/20100524/DI'
									 with: 'xmlns:dc' -> 'http://www.omg.org/spec/DD/20100524/DC'
									 with: 'xmlns:semantic' -> 'http://www.omg.org/spec/BPMN/20100524/MODEL'
									 with: 'xmlns:bpmn' -> 'http://www.omg.org/spec/BPMN/20100524/MODEL' ) 
			
			with: [ self visitSemantic: aRootElement model.
					  self visitDiagram: aRootElement]
]

{ #category : #initialization }
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

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitDiagramElement: anElement [
"<bpmndi:BPMNShape bpmnElement=""_6-0e5130ce-1e7d-0d00-a4c8-c2f20e3ea2c6"">
   <dc:Bounds height=""50.0"" width=""99.99720027997208"" x=""-54.998100189980946"" y=""-154.98700129987003""/>
   <bpmndi:BPMNLabel/>
</bpmndi:BPMNShape>"
	(anElement isKindOf: OPBPMNEdgeController)
		ifTrue: [ self visitDiagramFlow: anElement ]
		ifFalse: [ (anElement isKindOf: OPBPMNPoolController)
				ifTrue: [ self visitDiagramParticipant: anElement ]
				ifFalse: [ writer
						tag: self diagramNamespace , 'BPMNShape'
						attributes:
							(Array
								with:
									'bpmnElement'
										-> (anElement model printIdType , anElement model uuid asString))
						with: [ writer
								tag: 'dc:Bounds'
								attributes:
									(Array
										with: 'height' -> anElement figure height asString
										with: 'width' -> anElement figure width asString
										with:
											'x'
												-> (anElement figure position x 
													- (anElement figure width / 2.0)) asString
										with:
											'y'
												-> (anElement figure position y 
													- (anElement figure height / 2.0)) asString).
							writer tag: self diagramNamespace , 'BPMNLabel' ] ] ]
		
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitDiagramFlow: anElement [
"<bpmndi:BPMNEdge bpmnElement=""_6-0e5130ce-1e7d-0d00-a4cd-8bba0e3ea2c6"">
     <di:waypoint x=""-4.9995000499949045"" y=""-129.98700129987003""/>
     <di:waypoint x=""105.98940105989404"" y=""-129.98700129987""/>
 </bpmndi:BPMNEdge>"
	writer
		tag: self diagramNamespace , 'BPMNEdge'
		attributes:
			(Array
				with:
					'bpmnElement'
						-> (anElement model printIdType , anElement model uuid asString))
		with: [ writer
				tag: 'di:waypoint'
				attributes:
					(Array
						with: 'x' -> anElement source figure position x asString
						with: 'y' -> anElement source figure position y asString).
			writer
				tag: 'di:waypoint'
				attributes:
					(Array
						with: 'x' -> anElement target figure position x asString
						with: 'y' -> anElement target figure position y asString) ]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitDiagramParticipant: anElement [
	writer
		tag: self diagramNamespace , 'BPMNShape'
		attributes:
			(Array
				with: 'bpmnElement' -> ('participant_' , anElement model uuid asString))
		with: [ writer
				tag: 'dc:Bounds'
				attributes:
					(Array
						with: 'height' -> anElement figure height asString
						with: 'width' -> anElement figure width asString
						with:
							'x'
								-> (anElement figure position x 
									- (anElement figure width / 2.0)) asString
						with:
							'y'
								-> (anElement figure position y 
									- (anElement figure height / 2.0)) asString).
			writer tag: self diagramNamespace , 'BPMNLabel' ]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitElement: anElement [
"<semantic:startEvent name=""Address placed"" id=""_6-0e5130ce-1e7d-0d00-a4c6-bd810e3ea2c6"">"
	(anElement isKindOf: OPBPMNActivityModel)
		ifTrue: [ self visitElementActivity: anElement ]
		ifFalse: [ (anElement isKindOf: OPBPMNEventModel)
				ifTrue: [ self visitElementEvent: anElement ]
				ifFalse: [ writer
						tag: self namespace , anElement printType
						attributes:
							(Array
								with: 'name' -> anElement name
								with: 'id' -> (anElement printIdType , anElement uuid asString))
						with: [ (anElement isKindOf: OPBPMNPoolModel)
								| (anElement isKindOf: OPBPMNLaneModel)
								ifTrue: [ anElement nodes do: [ :each | self visitElement: each ].
									self allFlows
										do: [ :each | self visitFlow: each type: 'sequenceFlow' ].
									self allFlows do: [ :each | self removeFlow: each ] ].
							anElement incoming
								do: [ :each | self visitFlowRef: each inOut: 'incoming' ].
							anElement outgoing
								do: [ :each | self visitFlowRef: each inOut: 'outgoing' ] ] ] ]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitElementActivity: anElement [
"<semantic:serviceTask name=""Ping address"" id=""_6-0e5130ce-1e7d-0d00-a4c7-8c720e3ea2c6"" 							camunda:class=""PingAdapter"">"
	writer
		tag: self namespace , anElement printType
		attributes:
			(anElement executableAttribute
				ifNotNil: [ Array
						with: 'name' -> anElement name
						with: 'id' -> (anElement printIdType , anElement uuid asString)
						with: anElement executableAttribute -> anElement executableAttributeValue ]
				ifNil: [ Array
						with: 'name' -> anElement name
						with: 'id' -> (anElement printIdType , anElement uuid asString) ])
		with: [ anElement incoming
				do: [ :each | self visitFlowRef: each inOut: 'incoming' ].
			anElement outgoing
				do: [ :each | self visitFlowRef: each inOut: 'outgoing' ] ]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitElementEvent: anElement [
"<semantic:intermediateThrowEvent name=""Send message"" id=""_6-0e5130ce-1e7d-0d00-a4c9-c9b00e3ea2c6"" 											camunda:class=""MessageClass"">"
	writer
		tag: self namespace , anElement printType
		attributes:
			(anElement executableAttribute
				ifNotNil: [ Array
						with: 'name' -> anElement name
						with: 'id' -> (anElement printIdType , anElement uuid asString)
						with: anElement executableAttribute -> anElement executableAttributeValue ]
				ifNil: [ Array
						with: 'name' -> anElement name
						with: 'id' -> (anElement printIdType , anElement uuid asString) ])
		with: [ 
			anElement incoming
				do: [ :each | self visitFlowRef: each inOut: 'incoming' ].
			anElement outgoing
				do: [ :each | self visitFlowRef: each inOut: 'outgoing' ].
			(anElement type = OPBPMNNodeType Timer)
				ifTrue: [self visitElementEventTimer: anElement] ]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitElementEventTimer: anElement [
"<semantic:timerEventDefinition id=""timerEventDefinition_0e5130ce-1e7d-0d00-a4c9-c9b00e3ea2c6"">
 	<semantic:timeDuration xsi:type=""semantic:tFormalExpression"">PT5M</semantic:timeDuration>
 </semantic:timerEventDefinition>"
	(anElement timerType isNotNil)
		ifTrue: [ writer
				tag: self namespace , 'timerEventDefinition'
				attributes:
					(Array
						with: 'id' -> ('timerEventDefinition_' , anElement uuid asString))
				with: [ writer
						tag: self namespace , anElement timerType
						attributes: (Array with: 'xsi:type' -> 'semantic:tFormalExpression')
						with: anElement timerValue  ] ]
]

{ #category : #initialization }
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

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitFlowRef: aFlow inOut: inOut [
"<bpmn:outgoing>_6-0e5130ce-1e7d-0d00-a4c6-bd810e3ea2c6</bpmn:outgoing> or"
"<bpmn:incoming>_6-0e5130ce-1e7d-0d00-a4c7-8c720e3ea2c6</bpmn:incoming>"
	inOut = 'outgoing'
		ifTrue: [ aFlow printType = 'messageFlow'
				ifTrue: [ self addMessageFlow: aFlow ]
				ifFalse: [ self addFlow: aFlow ] ].
	writer
		tag: self namespace , inOut
		with: aFlow printIdType , aFlow source uuid asString
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitParticipantRef: anElement [
"<semantic:participant id=""participant_a96e59ae-477d-0d00-a841-8fa10a66547e"" 							 							processRef=""_6-a96e59ae-477d-0d00-a841-8fa10a66547e""/>"
	writer
		tag: self namespace , 'participant'
		attributes:
			(Array
				with: 'id' -> ('participant_' , anElement uuid asString)
				with: 'processRef' -> (anElement printIdType , anElement uuid asString))
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> visitSemantic: aRootElement [
"<semantic:process isExecutable=""false"" id=""process_0e5130ce-1e7d-0d00-a4c5-09a30e3ea2c6"">"
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
						with: 'isExecutable' -> aRootElement isExecutable asString
						with: 'id' -> (aRootElement printType , '_' , aRootElement uuid asString))
				with: [ aRootElement nodes do: [ :each | self visitElement: each ].
					self allFlows
						do: [ :each | self visitFlow: each type: 'sequenceFlow' ] ] ]
	"<semantic:collaboration id=""process_a96e59ae-477d-0d00-a842-a2480a66547e"">"
		ifFalse: [ aRootElement nodes do: [ :each | self visitElement: each ].
			writer
				tag: self namespace , 'collaboration'
				attributes:
					(Array
						with: 'id' -> (aRootElement printType , '_' , aRootElement uuid asString))
				with: [ aRootElement nodes
						do: [ :each | 
							(each isKindOf: OPBPMNPoolModel)
								ifTrue: [ self visitParticipantRef: each ] ].
					self allMessageFlows
						do: [ :each | self visitFlow: each type: 'messageFlow' ] ] ]
]

{ #category : #initialization }
OPBPMNXMLWriterVisitor >> writer [
	^ writer
]
