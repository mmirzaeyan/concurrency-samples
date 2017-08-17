/**
 * 
 */
package org.codePlus.framework.common;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import com.fasterxml.jackson.core.Version;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.deser.std.StringDeserializer;
import com.fasterxml.jackson.databind.module.SimpleModule;

/**
 * @author mohammad
 *
 */
public class HibernateAwareObjectMapper extends ObjectMapper{

	public HibernateAwareObjectMapper() {
		SimpleModule testModule = new SimpleModule("StringDeserializerModule", new Version(1, 0, 0, null));
		testModule.addDeserializer(String.class, new StringDeserializer());
		this.registerModule(testModule);
		DateFormat myDateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm");
		this.setDateFormat(myDateFormat); // 1.8 and above

		this.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
		System.out.println("HibernateAwareObjectMapper");
	}

	public void setPrettyPrint(boolean prettyPrint) {
		// configure(Feature.INDENT_OUTPUT, prettyPrint);
	}
}
