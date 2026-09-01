"
I am the ViewModel for the root OPBPMNModel, managing its UI representation and mapping its essential children (nodes and flows) into the diagram controllers.
"
Class {
	#name : 'OPBPMNModelViewModel',
	#superclass : 'OPModelObjectViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNModelViewModel class >> commonModelClassPrefix [

	^ 'OPBPMN'
]

{ #category : 'accessing' }
OPBPMNModelViewModel class >> modelClass [ ^ OPBPMNModel
]

{ #category : 'accessing' }
OPBPMNModelViewModel >> childrenModels [ ^ self model nodes
]

{ #category : 'accessing' }
OPBPMNModelViewModel >> essentialChildrenModels [
		| poolNodes poolFlows laneNodes laneFlows |
		poolNodes := self model nodes flatCollect: [ :each | each nodes ].
		poolFlows := poolNodes flatCollect: [ :each | each outgoing ].
		laneNodes := poolNodes flatCollect: [ :each | each nodes ].
		laneFlows := laneNodes flatCollect: [ :each | each outgoing ].
		^ self model nodes asArray , poolNodes asArray , poolFlows asArray , laneNodes asArray , laneFlows asArray
		  , (self model nodes flatCollect: [ :each | each outgoing ]) asArray
]

{ #category : 'accessing' }
OPBPMNModelViewModel >> icon [ ^ OPBPMNIcon current logo
]

{ #category : 'accessing' }
OPBPMNModelViewModel >> modelRootViewModel [

	^ self
]
