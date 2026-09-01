"
I am the abstract ViewModel for directional BPMN edges, connecting flow models to their corresponding UI forms and canvas shapes.
"
Class {
	#name : 'OPBPMNEdgeViewModel',
	#superclass : 'OPDirectedAssociationViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'testing' }
OPBPMNEdgeViewModel class >> isAbstract [

	^ self = OPBPMNEdgeViewModel
]

{ #category : 'accessing' }
OPBPMNEdgeViewModel class >> modelClass [ ^ OPBPMNEdgeModel
]
