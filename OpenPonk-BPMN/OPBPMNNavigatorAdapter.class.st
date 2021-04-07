Class {
	#name : #OPBPMNNavigatorAdapter,
	#superclass : #OPNavigatorAdapter,
	#category : #'OpenPonk-BPMN-Adapters'
}

{ #category : #'widget API' }
OPBPMNNavigatorAdapter >> childrenMapping [
	^ { (OPBPMNModel -> #nodes).
			(OPBPMNNodeModel -> #connected) }
]

{ #category : #'widget API' }
OPBPMNNavigatorAdapter >> displayMapping [
	^ {(OPBPMNModel -> 'Model').
	(OPBPMNActivityModel -> 'Activity').
	(OPBPMNStartEventModel -> 'Start Event').
	(OPBPMNFlowModel -> 'Sequence Flow')}
]

{ #category : #'widget API' }
OPBPMNNavigatorAdapter >> hasMappingFor: anObject [
	^ {OPBPMNModel.
	OPBPMNNodeModel.
	OPBPMNEdgeModel} anySatisfy: [ :any | anObject isKindOf: any ]
]

{ #category : #'widget API' }
OPBPMNNavigatorAdapter >> iconMapping [
	^ {(OPBPMNModel -> OPBPMNIcon current logo)}
]

{ #category : #'widget API' }
OPBPMNNavigatorAdapter >> sort: modelObjects [
	^ modelObjects
		sorted:
			[ :a :b | a name isNotNil and: [ b name isNil or: [ a name < b name ] ] ]
]

{ #category : #'widget API' }
OPBPMNNavigatorAdapter >> typesByDependency [
	^ {OPBPMNModel.
	OPBPMNNodeModel.
	OPBPMNEdgeModel }
]
