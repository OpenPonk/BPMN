"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestOpenPonkBPMNValidation',
	#superclass : 'PackageManifest',
	#category : 'OpenPonk-BPMN-Validation-Manifest',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestOpenPonkBPMNValidation class >> ruleBadMessageRule2V1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#'OpenPonk-BPMN-Validation')) #'2026-07-31T09:51:34.135+02:00') )
]

{ #category : 'code-critics' }
ManifestOpenPonkBPMNValidation class >> ruleUncommonMessageSendRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#'OpenPonk-BPMN-Validation')) #'2026-07-31T09:51:29.308+02:00') )
]
