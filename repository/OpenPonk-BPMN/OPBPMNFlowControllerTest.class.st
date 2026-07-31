Class {
	#name : 'OPBPMNFlowControllerTest',
	#superclass : 'OPBPMNAbstractFlowControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNFlowControllerTest >> controllerClass [
	^ OPBPMNFlowController
]

{ #category : 'constants' }
OPBPMNFlowControllerTest >> diagramElementClass [

	^ OPBPMNFlowShape 
]

{ #category : 'constants' }
OPBPMNFlowControllerTest >> modelClass [
	^ OPBPMNFlowModel 
]

{ #category : 'constants' }
OPBPMNFlowControllerTest >> sourceControllerClass [

	^ OPBPMNActivityController
]

{ #category : 'constants' }
OPBPMNFlowControllerTest >> sourceModelClass [
	^ OPBPMNActivityModel 
]
