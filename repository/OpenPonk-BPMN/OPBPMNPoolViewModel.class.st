"
I map the underlying BPMN Pool model to its UI representation. I build Magritte property forms for configuring pool and lane structures.
"
Class {
	#name : 'OPBPMNPoolViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNPoolViewModel class >> modelClass [ ^ OPBPMNPoolModel
]

{ #category : 'accessing' }
OPBPMNPoolViewModel >> auxiliaryRemovalCommandsIn: aProjectController [
	aProjectController ifNil: [ ^ #( ) ].
	^ (self model lanes flatCollect: [ :eachLane |
		eachLane elements copy collect: [ :eachElement |
			OPRemoveModelElementCommand
				model: eachElement
				projectController: aProjectController ] ]) asArray
]

{ #category : 'accessing' }
OPBPMNPoolViewModel >> icon [ ^ OPBPMNIcon current pool
]
