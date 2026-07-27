Class {
	#name : 'OPBPMNDataFlowShape',
	#superclass : 'OPBPMNAbstractFlowShape',
	#instVars : [
		'borderColor'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPBPMNDataFlowShape >> borderColor [

	^ borderColor
]

{ #category : 'rendering' }
OPBPMNDataFlowShape >> renderBasicShape [

	^ super renderBasicShape
		  dashed;
		  yourself
]

{ #category : 'accessing' }
OPBPMNDataFlowShape >> strokeColor: aColor [

	borderColor := aColor
]
