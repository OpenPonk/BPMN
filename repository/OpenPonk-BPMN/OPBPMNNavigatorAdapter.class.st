Class {
	#name : 'OPBPMNNavigatorAdapter',
	#superclass : 'OPNavigatorAdapter',
	#category : 'OpenPonk-BPMN-Adapters',
	#package : 'OpenPonk-BPMN',
	#tag : 'Adapters'
}

{ #category : 'accessing' }
OPBPMNNavigatorAdapter class >> priority [

	^ 10
]

{ #category : 'widget API' }
OPBPMNNavigatorAdapter >> childrenMapping [

	^ {
		  (OPBPMNModel -> [ :o | o nodes ]).
		  (OPBPMNNodeModel -> [ :o | o nodes , o outgoing ]) }
]

{ #category : 'widget API' }
OPBPMNNavigatorAdapter >> displayMapping [
	^ {(OPBPMNModel -> 'Model').
	(OPBPMNNodeModel -> 'Node').
	(OPBPMNPoolModel -> 'Pool').
	(OPBPMNSubProcessModel -> 'Expanded SubProcess').
	(OPBPMNCollapsedSubProcessModel -> 'Collapsed SubProcess').
	(OPBPMNBoundaryEventModel -> 'Boundary Event').
	(OPBPMNActivityModel -> 'Activity').
	(OPBPMNStartEventModel -> 'Start Event').
	(OPBPMNIntermediateEventModel -> 'Intermediate Event').
	(OPBPMNEndEventModel -> 'End Event').
	(OPBPMNGatewayModel -> 'Gateway').
	(OPBPMNDataObjectModel -> 'Data Object').
	(OPBPMNDataFlowModel -> 'Data Flow').
	(OPBPMNFlowModel -> 'Sequence Flow').
	(OPBPMNMessageFlowModel -> 'Message Flow')}
]

{ #category : 'widget API' }
OPBPMNNavigatorAdapter >> hasMappingFor: anObject in: aModel [

	^ { 
		  OPBPMNModel.
		  OPBPMNNodeModel.
		  OPBPMNEdgeModel } anySatisfy: [ :any | anObject isKindOf: any ]
]

{ #category : 'widget API' }
OPBPMNNavigatorAdapter >> iconMapping [
	^ {(OPBPMNModel -> OPBPMNIcon current logo).
		(OPBPMNActivityModel -> OPBPMNIcon current activity).
		(OPBPMNStartEventModel -> OPBPMNIcon current startEvent).
		(OPBPMNEndEventModel -> OPBPMNIcon current endEvent).
		(OPBPMNIntermediateEventModel -> OPBPMNIcon current intermediateEvent).
		(OPBPMNGatewayModel -> OPBPMNIcon current gateway).
		(OPBPMNPoolModel -> OPBPMNIcon current pool).
		(OPBPMNSubProcessModel -> OPBPMNIcon current expandedSubprocess).
		(OPBPMNCollapsedSubProcessModel -> OPBPMNIcon current subProcessCollapsed).
		(OPBPMNBoundaryEventModel -> OPBPMNIcon current intermediateEvent).
		(OPBPMNDataObjectModel -> OPBPMNIcon current dataObject16).
		(OPBPMNDataFlowModel -> OPBPMNIcon current messageFlow ).
		(OPBPMNFlowModel -> OPBPMNIcon current sequenceFlow ).
		(OPBPMNMessageFlowModel -> OPBPMNIcon current messageFlow )}
]

{ #category : 'widget API' }
OPBPMNNavigatorAdapter >> sort: modelObjects [
	^ modelObjects
		sorted:
			[ :a :b | a name isNotNil and: [ b name isNil or: [ a name < b name ] ] ]
]

{ #category : 'widget API' }
OPBPMNNavigatorAdapter >> typesByDependency [
	^ {OPBPMNModel.
	OPBPMNNodeModel.
	OPBPMNEdgeModel }
]
