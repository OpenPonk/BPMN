Class {
	#name : 'OPBPMNAnnotationController',
	#superclass : 'OPBPMNNodeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'connecting' }
OPBPMNAnnotationController >> canBeSourceFor: aController [

	^ aController isKindOf: OPBPMNAssociationController
]

{ #category : 'connecting' }
OPBPMNAnnotationController >> canBeTargetFor: aController [

	^ (aController isKindOf: OPBPMNAssociationController) and: [
		  aController source ~= self ]
]

{ #category : 'forms' }
OPBPMNAnnotationController >> descriptionName [

	<magritteDescription>
	| accessor |
	accessor := MAPluggableAccessor
		            read: [ :me | me model text ]
		            write: [ :me :newValue | 
			            me model text: newValue.
			            self modelChanged ].
	^ MAMemoDescription new
		  accessor: accessor;
		  label: 'Text';
		  priority: 1;
		  yourself
]

{ #category : 'construction' }
OPBPMNAnnotationController >> diagramElementClass [

	^ OPBPMNAnnotationShape
]

{ #category : 'accessing' }
OPBPMNAnnotationController >> modelClass [

	^ OPBPMNAnnotationModel
]
