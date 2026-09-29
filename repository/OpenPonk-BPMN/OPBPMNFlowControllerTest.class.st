"
I am a unit test class verifying the behavior of OPBPMNFlowController, focusing on correct source and target assignments for sequence flows.
"
Class {
	#name : 'OPBPMNFlowControllerTest',
	#superclass : 'OPBPMNAbstractFlowControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNFlowControllerTest class >> diagramElementClass [

	^ OPBPMNFlowShape 
]

{ #category : 'constants' }
OPBPMNFlowControllerTest >> controllerClass [
	^ OPBPMNFlowController
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
