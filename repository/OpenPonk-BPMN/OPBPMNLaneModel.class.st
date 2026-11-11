Class {
	#name : 'OPBPMNLaneModel',
	#superclass : 'OPBPMNNodeModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'accessing' }
OPBPMNLaneModel >> flowNodes [
	"Answers all direct flow nodes contained within this lane."
	^ (self elements select: [ :eachChildNode | eachChildNode isKindOf: OPBPMNFlowNodeModel ]) asOrderedCollection
]

{ #category : 'accessing' }
OPBPMNLaneModel >> pool [
	"Answer the enclosing BPMN pool model."
	^ self enclosingPool
]

{ #category : 'printing' }
OPBPMNLaneModel >> printIdType [
	^ '_6-'
]

{ #category : 'printing' }
OPBPMNLaneModel >> printType [
	^ 'lane'
]
