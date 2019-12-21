[#function convertType type language]
  [#if language == "csharp"]
    [#switch type]
      [#case "UUID"][#return "Guid?"/]
      [#case "boolean"][#return "bool?"/]
      [#case "int"]
      [#case "Integer"][#return "int?"/]
      [#case "ZonedDateTime"][#return "DateTimeOffset?"/]
      [#case "long"]
      [#case "Long"][#return "long?"]
      [#case "Void"][#return "RESTVoid"]
      [#case "LocalDate"]
      [#case "Locale"]
      [#case "URI"]
      [#case "ZoneId"]
      [#case "String"][#return "string"]
      [#case "Set"]
      [#case "Array"]
      [#case "SortedSet"][#return "List"]
      [#case "HashMap"]
      [#case "TreeMap"]
      [#case "LinkedHashMap"]
      [#case "Map"][#return "Dictionary"]
      [#case "*"][#return "T"][#--Note: ALL places where a wildcard was used in java needs to thread that template through to the api in c#--]
      [#case "Object"][#return "object"]
      [#default]
        [#if type?starts_with("Collection")]
          [#return type?replace("Collection", "List")?replace("UUID", "string")/]
        [#else]
          [#return type/]
        [/#if]
    [/#switch]
  [#elseif language == "go"]
    [#if type == "boolean" || type = "Boolean"]
      [#return "bool"/]
    [#elseif type == "Integer"]
      [#return "int"/]
    [#elseif type == "Long" || type == "long" || type == "ZonedDateTime" || type == "LocalDate"]
      [#return "int64"/]
    [#elseif type == "Void"]
      [#return "nil"/]
    [#elseif type?starts_with("Collection")]
      [#return type?replace("Collection", "[]")?replace("UUID", "string")?replace("<", "")?replace(">", "")/]
    [#elseif type == "String" || type = "UUID" || type == "ZoneId" || type == "URI" || type == "Locale"]
      [#return "string"/]
    [#elseif type == "Object" || type == "D" || type == "T"]
      [#return "interface{}"/]
    [#elseif type == "HTTPHeaders"]
      [#return "map[string]string"/]
    [#elseif type == "LocalizedIntegers"]
      [#return "map[string]int"/]
    [#elseif type == "LocalizedStrings"]
      [#return "map[string]string"/]
    [#else]
      [#return type/]
    [/#if]
  [#elseif language == "js"]
    [#switch type]
      [#case "ZonedDateTime"]
      [#case "byte"]
      [#case "int"]
      [#case "integer"]
      [#case "Int"]
      [#case "Integer"]
      [#case "long"]
      [#case "Long"][#return "number"/]
      [#case "LocalDate"]
      [#case "Locale"]
      [#case "URI"]
      [#case "ZoneId"]
      [#case "String"][#return "string"/]
      [#case "UUID"][#return "UUIDString"/]
      [#case "List"]
      [#case "SortedSet"][#return "Array"/]
      [#case "HashMap"]
      [#case "TreeMap"]
      [#case "LinkedHashMap"]
      [#case "Map"]
      [#case "Set"]
      [#case "*"]
      [#case "Object"][#return "Object"/]
      [#case "JWT"][#return "JWT | object"/]
      [#case "Void"][#return "void"/]
      [#default]
        [#if type?starts_with("Collection")]
          [#return type?replace("Collection", "Array")?replace("UUID", "string")/]
        [#else]
          [#return type/]
        [/#if]
    [/#switch]
  [#elseif language == "ts"]
    [#switch type]
      [#case "ZonedDateTime"]
      [#case "byte"]
      [#case "int"]
      [#case "integer"]
      [#case "Int"]
      [#case "Integer"]
      [#case "long"]
      [#case "Long"][#return "number"/]
      [#case "LocalDate"]
      [#case "Locale"]
      [#case "URI"]
      [#case "ZoneId"]
      [#case "String"][#return "string"/]
      [#case "List"][#return "Array"/]
      [#case "SortedSet"][#return "Set"/]
      [#case "HashMap"]
      [#case "TreeMap"]
      [#case "LinkedHashMap"][#return "Map"/]
      [#case "*"]
      [#case "Object"][#return "any"/]
      [#case "Void"][#return "void"/]
      [#default]
        [#if type?starts_with("Collection")]
          [#return type?replace("Collection", "Array")?replace("UUID", "string")/]
        [#else]
          [#return type/]
        [/#if]
    [/#switch]
  [#elseif language == "php"]
    [#if type == "UUID" || type == "String"]
      [#return "string"/]
    [#elseif type == "boolean" || type == "Boolean"]
      [#return "boolean"/]
    [#elseif type == "int" || type == "Integer"]
      [#return "int"/]
    [#elseif type == "float" || type == "Float"]
      [#return "float"/]
    [#else]
      [#return "array"/]
    [/#if]
  [#elseif language == "ruby"]
    [#if type == "UUID" || type == "String"]
      [#return "string"/]
    [#elseif type?starts_with("Collection")]
      [#return "Array"/]
    [#elseif type == "boolean" || type == "Boolean"]
      [#return "Boolean"/]
    [#elseif type == "int" || type == "Integer"]
      [#return "Numeric"/]
    [#elseif type == "float" || type == "Float"]
      [#return "Numeric"/]
    [#else]
      [#return "OpenStruct, Hash"/]
    [/#if]
  [/#if]
  [#return type/]
[/#function]

[#function convertValue param language]
  [#if language == "ruby"]
    [#if param == "end"]
      [#return "_end"/]
    [/#if]
  [#elseif language == "python"]
    [#if param.constant?? && param.constant]
    [#--Special value conditions for python--]
      [#if param.value?? && param.value == "true"]
        [#return '"true"']
      [#elseif param.value?? && param.value == "false"]
        [#return '"false"']
      [/#if]
    [#else]
    [#--Special name conditions for python--]
      [#if param.name == "global"]
        [#return "_global"]
      [/#if]
    [/#if]
  [#elseif language == "go"]
    [#if param == "type"]
      [#return "_type"];
    [/#if]
    [#return toCamelCase(param)]
  [/#if]
  [#return (param.constant?? && param.constant)?then(param.value, camel_to_underscores(param.name))/]
[/#function]

[#function optional param language]
  [#if language == "js"]
    [#return param.comments[0]?starts_with("(Optional)")?then("?", "")/]
  [#else]
    [#return ""/]
  [/#if]
[/#function]

[#function methodParameters api language]
  [#local result = []]
  [#if language == "python"]
    [#local result = result + ["self"]]
  [/#if]
  [#list api.params![] as param]
    [#if !param.constant??]
      [#local optional = param.comments[0]?starts_with("(Optional)")/]
      [#if language == "php"]
        [#-- If the parameter is the last one and is optional, give it a default value --]
        [#if !param_has_next && optional]
          [#local result = result + ["$" + param.name + " = NULL"]/]
        [#else]
          [#local result = result + ["$" + param.name]/]
        [/#if]
      [#elseif language == "js"]
        [#local result = result + [param.name]/]
      [#elseif language == "ts"]
        [#local convertedType = convertType(param.javaType, language)/]
        [#local result = result + [param.name + (convertedType != "Object")?then(': ' + convertedType, '')]]
      [#elseif language == "go"]
        [#local convertedType = convertType(param.javaType, language)/]
        [#if api.method == "patch" && convertedType?ends_with("Request")]
          [#local convertedType = "map[string]interface{}"/]
        [/#if]
        [#local result = result + [convertValue(param.name, language) + (convertedType != "interface{}")?then(' ' + convertedType, ' interface{}')]]
      [#elseif language == "python"]
        [#-- If the parameter is optional, give it a default value --]
        [#if optional]
          [#local result = result + [convertValue(param, language) + "=None"]/]
        [#else]
          [#local result = result + [convertValue(param, language)]/]
        [/#if]
      [#elseif language == "ruby"]
        [#if param.name == "end"]
          [#local result = result + ["_end"]/]
        [#else]
          [#local result = result + [camel_to_underscores(param.name)]/]
        [/#if]
      [#elseif language == "csharp"]
        [#local convertedType = convertType(param.javaType, language)/]
          [#if api.method == "patch" && param.javaType?ends_with("Request")]
            [#local convertedType = "Dictionary<string, object>"/]
          [/#if]
          [#local result = result + [convertedType + " " + param.name]/]
      [#elseif language == "java"]
        [#local convertedType = convertType(param.javaType, language)/]
        [#if api.method == "patch" && param.javaType?ends_with("Request")]
          [#local convertedType = "Map<String, Object>"/]
        [/#if]
        [#local result = result + [convertedType + " " + param.name]/]
      [#else]
        [#local result = result + [convertType(param.javaType, language) + " " + param.name]/]
      [/#if]
    [/#if]
  [/#list]
  [#if language == "python"]
    [#-- Ensure optional parameters follow mandatory parameters --]
    [#local mandatory = []]
    [#local optional = []]
    [#list result as param]
      [#if !param?contains("=None")]
        [#local mandatory = mandatory + [param]/]
      [#else]
        [#local optional = optional + [param]/]
      [/#if]
    [/#list]
    [#local result = mandatory + optional]
  [/#if]
  [#return result?join(", ")/]
[/#function]

[#function hasBodyParam params]
  [#list params as param]
    [#if param.type == "body"]
      [#return true]
    [/#if]
  [/#list]
  [#return false]
[/#function]

[#function innerComment comment]
  [#local lines = comment?split("\n")/]
  [#return lines[1..<(lines?size-2)]?join("\n")/]
[/#function]

[#function needsConverter domain_item]
    [#switch domain_item.type]
      [#case "IdentityProviderType"]
      [#case "LambdaType"]
        [#return false]
      [#default]
        [#list domain_item.enum as enum]
          [#if enum?is_hash && enum.args?? && enum.args?size == 1]
              [#return true]
          [/#if]
        [/#list]
        [#return false]
    [/#switch]
[/#function]

[#function hasAnySetter domain_item]
  [#list domain_item.fields!{} as name, field]
    [#if field.anySetter?? && field.anySetter]
      [#return true]
    [/#if]
  [/#list]
  [#return false]
[/#function]

[#function toCamelCase underScore]
  [#local camelCase = ""]
  [#list underScore?split("_") as word]
    [#if word?is_first]
      [#local camelCase = camelCase + word]
    [#else]
      [#local camelCase = camelCase + word?cap_first]
    [/#if]
  [/#list]
  [#return camelCase]
[/#function]

[#function scrubName name]
  [#return name?replace("#", "_")/]
[/#function]
