"
Manifest for the OpenPonk BPMN Simulation package. Contains metadata and settings for the BPMN simulation plugin and its critic rules.
"
Class {
	#name : 'ManifestOpenPonkBPMNSimulation',
	#superclass : 'PackageManifest',
	#category : 'OpenPonk-BPMN-Simulation-Manifest',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestOpenPonkBPMNSimulation class >> ruleBadMessageRule2V1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#'OpenPonk-BPMN-Simulation')) #'2026-07-31T09:52:26.263+02:00') )
]

{ #category : 'code-critics' }
ManifestOpenPonkBPMNSimulation class >> ruleUncommonMessageSendRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#'OpenPonk-BPMN-Simulation')) #'2026-07-31T09:51:47.103+02:00') )
]
