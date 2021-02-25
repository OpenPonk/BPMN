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
	^ { (OPBPMNModel -> 'Model') }
]

{ #category : #'widget API' }
OPBPMNNavigatorAdapter >> hasMappingFor: anObject [
	^ {OPBPMNModel} anySatisfy: [ :any | anObject isKindOf: any ]
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
