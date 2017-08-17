package org.cocurrency.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.hibernate.JDBCException;
import org.omg.CORBA.portable.ApplicationException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.context.request.WebRequest;

@Controller
public class BaseController {
	private final Logger	logger	= Logger.getLogger(BaseController.class);

	@ExceptionHandler(Exception.class)
	@ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR)
	@ResponseBody
	public ResponseEntity<String> handleUncaughtException(Exception ex, WebRequest request, HttpServletResponse response) throws IOException {
		String logMessage = ex.toString() + " " + ex.getMessage();

		if (ex.getCause() != null) {
			logMessage += ex.getCause().toString() + " " + ex.getCause().getMessage();
			logMessage += getStackTrace(ex);
		}

		if (ex instanceof org.hibernate.exception.ConstraintViolationException) {
			org.hibernate.exception.ConstraintViolationException constraintViolationException = (org.hibernate.exception.ConstraintViolationException) ex;
			logMessage += " constraintName " + constraintViolationException.getConstraintName();
			logMessage += " errorCode " + constraintViolationException.getErrorCode();
			logMessage += " message " + constraintViolationException.getMessage();
			logMessage += " sql " + constraintViolationException.getSQL();
		}

		if (ex instanceof JDBCException) {
			JDBCException jDBCException = (JDBCException) ex;
			logMessage += " sQL " + jDBCException.getSQL();
		}

		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "application/json;charset=utf-8");
		logger.log(Level.ERROR, logMessage);

		return new ResponseEntity<String>(" ", responseHeaders, HttpStatus.INTERNAL_SERVER_ERROR);
	}

	@ExceptionHandler(ApplicationException.class)
	@ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR)
	@ResponseBody
	public ResponseEntity<String> handleApplicationException(ApplicationException ex, WebRequest request, HttpServletResponse response) throws IOException {
		String exceptionMessage = ((ApplicationException) ex).getMessage();

		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "application/json;charset=utf-8");
		logger.log(Level.ERROR, exceptionMessage);

		return new ResponseEntity<String>(exceptionMessage, responseHeaders, HttpStatus.INTERNAL_SERVER_ERROR);
	}

	public static String getStackTrace(final Throwable throwable) {
		final StringWriter sw = new StringWriter();
		final PrintWriter pw = new PrintWriter(sw, true);
		throwable.printStackTrace(pw);
		return sw.getBuffer().toString();
	}


	public static boolean isAjaxRequest(WebRequest webRequest) {
		String requestedWith = webRequest.getHeader("X-Requested-With");
		return requestedWith != null ? "XMLHttpRequest".equals(requestedWith) : false;
	}

}
