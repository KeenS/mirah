# Copyright (c) 2012 The Mirah project authors. All Rights Reserved.
# All contributing project authors may be found in the NOTICE file.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package org.mirah.jvm.model

import java.util.ArrayList
import javax.lang.model.element.TypeElement as TypeElementModel
import org.mirah.jvm.mirrors.MirrorType

class TypeElement implements TypeElementModel
  def initialize(type:MirrorType)
    @type = type
  end

  def descriptor
    @type.class_id
  end

  def equals(other)
    other.kind_of?(TypeElement) &&
        descriptor.equals(TypeElement(other).descriptor)
  end

  def hashCode
    descriptor.hashCode
  end
end