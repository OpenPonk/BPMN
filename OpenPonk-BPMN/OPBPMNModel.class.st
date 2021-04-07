Class {
	#name : #OPBPMNModel,
	#superclass : #OPModelObject,
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #accessing }
OPBPMNModel >> allEntities [
	^ Set with: self nodes
]

{ #category : #accessing }
OPBPMNModel >> edges [
	^ elements select: #isEdge
]

{ #category : #accessing }
OPBPMNModel >> nodes [
	^ elements select: #isNode
]
