Class {
	#name : #OPBPMNNavigatorAdapter,
	#superclass : #OPNavigatorAdapter,
	#category : #'OpenPonk-BPMN-Adapters'
}

{ #category : #'widget API' }
OPBPMNNavigatorAdapter >> childrenMapping [
	^ { (OPBPMNModel -> #participants) }
]

{ #category : #'widget API' }
OPBPMNNavigatorAdapter >> displayMapping [
	^ {(OPBPMNModel -> 'Model').
	OPBPMNFlowModel -> 'Sequence Flow'}
]

{ #category : #'widget API' }
OPBPMNNavigatorAdapter >> hasMappingFor: anObject [
	^ {OPBPMNModel.
	OPBPMNNodeModel.
	OPBPMNEdgeModel} anySatisfy: [ :any | anObject isKindOf: any ]
]

{ #category : #'widget API' }
OPBPMNNavigatorAdapter >> iconMapping [
	^ { }
]

{ #category : #'widget API' }
OPBPMNNavigatorAdapter >> typesByDependency [
	^ {OPBPMNModel.
	OPBPMNNodeModel.
	OPBPMNEdgeModel }
]
