import 'dart:ffi';

import 'bindings.dart';
import 'typedefs.dart';

extension TypedExtensionOrtApi on OrtApi {
  // [OrtEnv] Methods
  CreateEnv get createEnv => this.CreateEnv.asFunction(isLeaf: true);

  // [OrtAllocator]
  GetAllocatorWithDefaultOptions get getAllocatorWithDefaultOptions =>
      this.GetAllocatorWithDefaultOptions.asFunction(isLeaf: true);

  // [OrtSession] Methods
  CreateSession get createSession =>
      this.CreateSession.asFunction(isLeaf: true);

  CreateSessionFromArray get createSessionFromArray =>
      this.CreateSessionFromArray.asFunction(isLeaf: true);

  // [OrtSessionOptions] methods
  CreateSessionOptions get createSessionOptions =>
      this.CreateSessionOptions.asFunction(isLeaf: true);

  // [OrtModelMetadata] Methods
  SessionGetModelMetadata get sessionGetModelMetadata =>
      this.SessionGetModelMetadata.asFunction(isLeaf: true);

  ModelMetadataGetVersion get modelMetadataGetVersion =>
      this.ModelMetadataGetVersion.asFunction(isLeaf: true);

  ModelMetadataGetStringProperty get modelMetadataGetDomain =>
      this.ModelMetadataGetDomain.asFunction(isLeaf: true);

  ModelMetadataGetStringProperty get modelMetadataGetProducerName =>
      this.ModelMetadataGetProducerName.asFunction(isLeaf: true);

  ModelMetadataGetStringProperty get modelMetadataGetGraphName =>
      this.ModelMetadataGetGraphName.asFunction(isLeaf: true);

  ModelMetadataGetStringProperty get modelMetadataGetGraphDescription =>
      this.ModelMetadataGetGraphDescription.asFunction(isLeaf: true);

  ModelMetadataGetCustomMetadataMapKeys
  get modelMetadataGetCustomMetadataMapKeys =>
      this.ModelMetadataGetCustomMetadataMapKeys.asFunction(isLeaf: true);

  ModelMetadataLookupCustomMetadataMap
  get modelMetadataLookupCustomMetadataMap =>
      this.ModelMetadataLookupCustomMetadataMap.asFunction(isLeaf: true);
}
