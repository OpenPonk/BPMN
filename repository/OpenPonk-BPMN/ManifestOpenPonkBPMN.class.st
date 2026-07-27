"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestOpenPonkBPMN',
	#superclass : 'PackageManifest',
	#category : 'OpenPonk-BPMN-Manifest',
	#package : 'OpenPonk-BPMN',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestOpenPonkBPMN class >> ruleBadMessageRule2V1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#OPBPMNPoolController #canBeTargetFor: #false)) #'2026-07-22T13:52:22.576+02:00') #(#(#RGMethodDefinition #(#OPBPMNPoolController #canBeSourceFor: #false)) #'2026-07-22T13:52:27.537+02:00') #(#(#RGMethodDefinition #(#OPBPMNActivityController #canBeSourceFor: #false)) #'2026-07-22T13:52:39.45+02:00') #(#(#RGMethodDefinition #(#OPBPMNActivityController #canBeTargetFor: #false)) #'2026-07-22T13:53:25.2+02:00') #(#(#RGMethodDefinition #(#OPBPMNStartEventController #canBeSourceFor: #false)) #'2026-07-22T13:54:08.908+02:00') #(#(#RGMethodDefinition #(#OPBPMNStartEventController #canBeTargetFor: #false)) #'2026-07-22T13:54:24.366+02:00') #(#(#RGMethodDefinition #(#OPBPMNEndEventController #canBeSourceFor: #false)) #'2026-07-22T13:54:45.461+02:00') #(#(#RGMethodDefinition #(#OPBPMNEndEventController #canBeTargetFor: #false)) #'2026-07-22T13:55:29.905+02:00') #(#(#RGMethodDefinition #(#OPBPMNCollapsedSubProcessController #canBeTargetFor: #false)) #'2026-07-22T14:10:42.561+02:00') #(#(#RGMethodDefinition #(#OPBPMNBoundaryEventController #canBeTargetFor: #false)) #'2026-07-22T14:10:47.143+02:00') #(#(#RGMethodDefinition #(#OPBPMNBoundaryEventController #canBeSourceFor: #false)) #'2026-07-22T14:11:04.054+02:00') #(#(#RGMethodDefinition #(#OPBPMNCollapsedSubProcessController #canBeSourceFor: #false)) #'2026-07-22T14:11:13.415+02:00') #(#(#RGMethodDefinition #(#OPBPMNSubProcessController #canBeSourceFor: #false)) #'2026-07-22T14:11:30.246+02:00') #(#(#RGMethodDefinition #(#OPBPMNSubProcessController #canBeTargetFor: #false)) #'2026-07-22T14:11:41.894+02:00') #(#(#RGMethodDefinition #(#OPBPMNIntermediateEventController #canBeSourceFor: #false)) #'2026-07-22T14:12:22.16+02:00') #(#(#RGMethodDefinition #(#OPBPMNIntermediateEventController #canBeTargetFor: #false)) #'2026-07-22T14:12:30.226+02:00') #(#(#RGMethodDefinition #(#OPBPMNGatewayController #canBeTargetFor: #false)) #'2026-07-23T09:43:45.261+02:00') #(#(#RGMethodDefinition #(#OPBPMNGatewayController #canBeSourceFor: #false)) #'2026-07-23T09:43:49.966+02:00') )
]

{ #category : 'code-critics' }
ManifestOpenPonkBPMN class >> ruleCollectionMessagesToExternalObjectRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#OPBPMNSemanticNodeController #removeModel #false)) #'2024-05-30T12:30:45.597+02:00') )
]

{ #category : 'code-critics' }
ManifestOpenPonkBPMN class >> rulePrecedenceRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#OPBPMNPoolController #rebuildLaneNamesFrom:inForm: #false)) #'2026-07-23T15:28:38.21+02:00') )
]

{ #category : 'code-critics' }
ManifestOpenPonkBPMN class >> ruleUncommonMessageSendRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#OPBPMNIntermediateEventModel #printType #false)) #'2026-07-22T12:55:46.155+02:00') #(#(#RGPackageDefinition #(#'OpenPonk-BPMN')) #'2026-07-31T09:52:11.177+02:00') )
]
