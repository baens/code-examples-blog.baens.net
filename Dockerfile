FROM gradle:5.0.0-jdk11 as BUILD

RUN mkdir -p /home/gradle/src
WORKDIR /home/gradle/src
COPY . /home/gradle/src
RUN gradle -s --no-daemon shadowJar

FROM openjdk:11.0.1-jre

COPY --from=BUILD /home/gradle/src/build/libs/step-by-step-kotlin-all.jar /bin/runner/run.jar
WORKDIR /bin/runner

CMD ["java","-jar","run.jar"]